document.addEventListener('DOMContentLoaded', function () {
    const controlPanel = document.getElementById('controlPanel');

    // Create audio element for click sound
    const clickAudio = new Audio('sounds/click.wav');
    clickAudio.preload = 'auto';

    // Track the current knob angle
    let currentKnobAngle = -180;
    let knobAnimationFrame = null;

    // Default colors/icon for disabled buttons
    const disabledButtonColor = { r: 71, g: 71, b: 71 };
    // const disabledButtonIcon = 'disabled-icon.svg';

    // Set up the 9th button (9) for headlights permanently
    const headlightButton = document.querySelector('.button[data-action="9"]');
    if (headlightButton) {
        // Set headlight button to default state (low beam icon, dimmed)
        headlightButton.style.backgroundColor = 'rgb(71, 71, 71)'; // Default gray color
        headlightButton.innerHTML = `<img src="./images/low-beam-icon.svg" alt="headlight" style="width: 30px; height: 30px; filter: brightness(0) invert(1);">`;
        headlightButton.style.opacity = '0.5'; // Start dimmed
    }

    // Helper to animate knob to target angle using shortest path
    function animateKnobTo(targetAngle) {
        if (knobAnimationFrame) cancelAnimationFrame(knobAnimationFrame);
        const knobLine = document.querySelector('.knob-line');
        if (!knobLine) return;
        let start = null;
        const duration = 200; // ms
        const startAngle = currentKnobAngle;
        let delta = targetAngle - startAngle;
        // Shortest path logic
        if (delta > 180) delta -= 360;
        if (delta < -180) delta += 360;
        function step(timestamp) {
            if (!start) start = timestamp;
            const elapsed = timestamp - start;
            const progress = Math.min(elapsed / duration, 1);
            const ease = progress < 0.5 ? 2 * progress * progress : -1 + (4 - 2 * progress) * progress; // easeInOut
            const angle = startAngle + delta * ease;
            knobLine.style.transform = `translateX(-50%) rotate(${angle}deg)`;
            if (progress < 1) {
                knobAnimationFrame = requestAnimationFrame(step);
            } else {
                knobLine.style.transform = `translateX(-50%) rotate(${targetAngle}deg)`;
                currentKnobAngle = targetAngle;
            }
        }
        requestAnimationFrame(step);
    }

    // Handle NUI messages
    window.addEventListener('message', function (event) {
        const item = event.data;
        if (item.type === 'ui') {
            if (item.display === true) {
                // Show the panel first
                controlPanel.style.display = 'flex';

                // Trigger the transition after a small delay to ensure display is set
                setTimeout(() => {
                    controlPanel.classList.add('show');
                }, 10);

                // Update buttons before showing UI
                // Set all buttons to disabled state first
                document.querySelectorAll('.button').forEach((button) => {
                    // Skip the 9th and 10th buttons as they have their own content
                    if (button.getAttribute('data-action') === '9' || button.getAttribute('data-action') === '10') {
                        return;
                    }

                    button.style.backgroundColor = `rgb(${disabledButtonColor.r},${disabledButtonColor.g},${disabledButtonColor.b})`;
                    // button.innerHTML = `<img src="./images/${disabledButtonIcon}" alt="icon" style="width: 30px; height: 30px; filter: brightness(0) invert(1);">`;
                });

                if (item.buttons) {
                    Object.entries(item.buttons).forEach(([key, btn]) => {
                        // Find the button by data-action attribute if key is a string, or by index if numeric
                        const button = document.querySelector(`.button[data-action="${key}"]`);
                        if (button) {
                            // Skip updating the 9th and 10th buttons as they're reserved for headlights and indicators
                            if (button.getAttribute('data-action') === '9' || button.getAttribute('data-action') === '10') {
                                return;
                            }

                            // Set background color
                            if (btn.color) {
                                let color = btn.color;
                                if (typeof color === 'object' && color.r !== undefined && color.g !== undefined && color.b !== undefined) {
                                    // Convert to CSS rgb string
                                    color = `rgb(${color.r},${color.g},${color.b})`;
                                }
                                button.style.backgroundColor = color;
                            }
                            // Set text or icon
                            if (btn.text) {
                                if (btn.text.endsWith && btn.text.endsWith('.svg')) {
                                    // SVG icon
                                    button.innerHTML = `<img src="./images/${btn.text}" alt="icon" style="width: 30px; height: 30px; filter: brightness(0) invert(1);">`;
                                } else if (btn.text.startsWith && btn.text.startsWith('fa-')) {
                                    // FontAwesome icon
                                    button.innerHTML = `<i class='fa ${btn.text}'></i>`;
                                } else {
                                    button.textContent = btn.text;
                                }
                            } else {
                                button.textContent = '';
                            }
                        }
                    });
                }
            } else {
                // Remove the show class to trigger fade out
                controlPanel.classList.remove('show');

                // Hide the panel after transition completes
                setTimeout(() => {
                    controlPanel.style.display = 'none';
                }, 300); // Match the transition duration
            }
        } else if (item.type === 'updateLightState') {
            if (item.doSound) {
                // Play click sound
                clickAudio.currentTime = 0;
                clickAudio.play();
            }

            // First we remove all the active classes
            const buttons = document.querySelectorAll('.button');
            buttons.forEach((button) => button.classList.remove('active'));

            // Then we add the active class to the buttons that are active
            for (const lightIndex of item.state) {
                const button = document.querySelector(`[data-action="${lightIndex}"]`);
                if (button) {
                    button.classList.add('active'); // Add an 'active' class for styling
                }
            }
        } else if (item.type === 'updateSirenState') {
            if (item.doSound) {
                // Play click sound
                clickAudio.currentTime = 0;
                clickAudio.play();
            }

            // Handle siren state updates for the rotary knob
            const knobOptions = document.querySelectorAll('.knob-option');
            knobOptions.forEach((option) => option.classList.remove('active'));
            let rotation = 0;
            let selectedOption = null;
            // Define angles for each state
            const angles = {
                OFF: -180,
                1: -90,
                2: -45,
                3: 0,
                4: 45,
                5: 90,
            };
            // Mapping from siren state to CSS class name
            const stateToClassName = {
                OFF: 'off',
                1: 'one',
                2: 'two',
                3: 'three',
                4: 'four',
                5: 'five',
            };
            const stateKey = String(item.state); // Ensure state is a string
            if (angles[stateKey] !== undefined) {
                rotation = angles[stateKey];
                const className = stateToClassName[stateKey];
                if (className) {
                    selectedOption = document.querySelector(`.knob-option.${className}`);
                }
            } else {
                // Default to OFF if state is unknown or invalid
                rotation = angles['OFF'];
                selectedOption = document.querySelector('.knob-option.off');
            }
            animateKnobTo(rotation);
            if (selectedOption) {
                selectedOption.classList.add('active');
            }
        } else if (item.type === 'updateIndicatorState') {
            // Handle indicator state updates
            const leftArrow = document.querySelector('.indicator-left');
            const rightArrow = document.querySelector('.indicator-right');
            const indicatorButton = document.querySelector('.button[data-action="10"]');

            if (leftArrow && rightArrow && indicatorButton) {
                // Remove active and blinking classes from both arrows first
                leftArrow.classList.remove('active', 'blinking');
                rightArrow.classList.remove('active', 'blinking');

                // Apply active state and blinking based on indicatorState
                switch (item.state) {
                    case 0: // Both indicators off
                        indicatorButton.style.opacity = 0.5;
                        break;
                    case 1: // Left indicator on
                        leftArrow.classList.add('active', 'blinking');
                        indicatorButton.style.opacity = 1;
                        break;
                    case 2: // Right indicator on
                        rightArrow.classList.add('active', 'blinking');
                        indicatorButton.style.opacity = 1;
                        break;
                    case 3: // Both indicators on
                        // Remove and re-add blinking to both arrows to sync animation
                        leftArrow.classList.remove('blinking');
                        rightArrow.classList.remove('blinking');
                        // Force reflow to restart animation
                        void leftArrow.offsetWidth;
                        leftArrow.classList.add('active', 'blinking');
                        rightArrow.classList.add('active', 'blinking');
                        indicatorButton.style.opacity = 1;
                        break;
                }
            }
        } else if (item.type === 'updateHeadLightState') {
            // Handle headlight state updates
            const headlightButton = document.querySelector('.button[data-action="9"]');

            if (headlightButton) {
                if (item.state.lightsOn || item.state.highBeamsOn) {
                    // Lights are on - set opacity to 1.0
                    headlightButton.style.opacity = '1.0';

                    if (item.state.highBeamsOn) {
                        // High beams are on - show high beam icon in blue
                        headlightButton.innerHTML = `<img src="./images/high-beam-icon.svg" alt="high beam" style="width: 30px; height: 30px; filter: brightness(0) saturate(100%) invert(69%) sepia(14%) saturate(5183%) hue-rotate(169deg) brightness(84%) contrast(92%);">`;
                    } else {
                        // Low beams are on - show low beam icon in green
                        headlightButton.innerHTML = `<img src="./images/low-beam-icon.svg" alt="low beam" style="width: 30px; height: 30px; filter: brightness(0) saturate(100%) invert(58%) sepia(36%) saturate(789%) hue-rotate(77deg) brightness(93%) contrast(93%);">`;
                    }
                } else {
                    // Lights are off - set opacity to 0.5 and show low beam icon in gray
                    headlightButton.style.opacity = '0.5';
                    headlightButton.innerHTML = `<img src="./images/low-beam-icon.svg" alt="low beam" style="width: 30px; height: 30px; filter: brightness(0) invert(1);">`;
                }
            }
        }
    });

    // Close NUI when pressing ESC
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            fetch(`https://${GetParentResourceName()}/closeUI`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({}),
            });
        }
    });
});

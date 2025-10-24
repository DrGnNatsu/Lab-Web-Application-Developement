document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('serviceForm');

    // Helper function to show error message
    const showError = (element, message) => {
        const errorDiv = document.getElementById(`${element.id}-error`);
        if (errorDiv) {
            errorDiv.textContent = message;
        }
    };

    // Helper function to clear error message
    const clearError = (element) => {
        const errorDiv = document.getElementById(`${element.id}-error`);
        if (errorDiv) {
            errorDiv.textContent = '';
        }
    };

    // Custom validation messages
    const getErrorMessage = (input) => {
        if (input.validity.valueMissing) {
            return 'This field is required.';
        }

        if (input.validity.typeMismatch) {
            switch (input.type) {
                case 'email':
                    return 'Please enter a valid email address.';
                case 'tel':
                    return 'Please enter a valid phone number.';
                default:
                    return 'Please enter a valid value.';
            }
        }

        if (input.validity.patternMismatch) {
            switch (input.id) {
                case 'phone':
                    return 'Please enter a valid international phone number (e.g., +1234567890).';
                case 'password':
                    return 'Password must be at least 8 characters long and contain both letters and numbers.';
                default:
                    return 'Please match the requested format.';
            }
        }

        if (input.validity.tooShort) {
            return `Please use at least ${input.minLength} characters.`;
        }

        if (input.validity.tooLong) {
            return `Please use no more than ${input.maxLength} characters.`;
        }

        if (input.validity.rangeUnderflow) {
            return `Please enter a value greater than or equal to ${input.min}.`;
        }

        if (input.validity.rangeOverflow) {
            return `Please enter a value less than or equal to ${input.max}.`;
        }

        return '';
    };

    // Handle input validation
    const validateInput = (input) => {
        clearError(input);
        if (!input.validity.valid) {
            showError(input, getErrorMessage(input));
            return false;
        }
        return true;
    };

    // Validate radio group
    const validateRadioGroup = (name) => {
        const radioButtons = form.querySelectorAll(`input[name="${name}"]`);
        const isChecked = Array.from(radioButtons).some(radio => radio.checked);
        const errorDiv = document.getElementById(`${name}-error`);

        if (!isChecked && radioButtons[0].required) {
            if (errorDiv) errorDiv.textContent = 'Please select an option.';
            return false;
        }
        if (errorDiv) errorDiv.textContent = '';
        return true;
    };

    // Add input event listeners to all form controls
    form.querySelectorAll('input, select, textarea').forEach(input => {
        input.addEventListener('input', () => validateInput(input));
        input.addEventListener('blur', () => validateInput(input));
    });

    // Handle form submission
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        let isValid = true;

        // Validate all inputs
        form.querySelectorAll('input, select, textarea').forEach(input => {
            if (input.type !== 'radio' && input.type !== 'hidden') {
                if (!validateInput(input)) isValid = false;
            }
        });

        // Validate radio groups
        if (!validateRadioGroup('focus')) isValid = false;

        if (isValid) {
            // Show loading state
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            submitButton.disabled = true;
            submitButton.textContent = 'Sending...';

            // Simulate form submission (replace with actual submission logic)
            setTimeout(() => {
                alert('Form submitted successfully!');
                form.reset();
                submitButton.disabled = false;
                submitButton.textContent = originalText;
            }, 1000);
        }
    });

    // Handle form reset
    form.addEventListener('reset', () => {
        // Clear all error messages
        form.querySelectorAll('[id$="-error"]').forEach(errorDiv => {
            errorDiv.textContent = '';
        });
    });

    // Handle file input validation
    const fileInput = document.getElementById('resume');
    if (fileInput) {
        fileInput.addEventListener('change', () => {
            const file = fileInput.files[0];
            if (file) {
                const allowedTypes = ['.pdf', 'image/png', 'image/jpeg'];
                const fileType = file.type || `.${file.name.split('.').pop()}`;

                if (!allowedTypes.includes(fileType)) {
                    showError(fileInput, 'Please upload a PDF or image file (PNG/JPG).');
                    fileInput.value = '';
                } else if (file.size > 5 * 1024 * 1024) { // 5MB limit
                    showError(fileInput, 'File size must be less than 5MB.');
                    fileInput.value = '';
                } else {
                    clearError(fileInput);
                }
            }
        });
    }
});
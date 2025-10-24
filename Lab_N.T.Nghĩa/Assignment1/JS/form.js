// Create notification function
function createNotification(message, type) {
    // Create notification container if it doesn't exist
    let container = document.querySelector('.notification-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'notification-container';
        document.body.appendChild(container);
    }

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;

    // Create content
    const content = document.createElement('div');
    content.className = 'notification-content';

    // Add icon based on type
    const icon = document.createElement('span');
    icon.className = 'notification-icon';
    icon.innerHTML = type === 'success'
        ? '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16"><path d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"/></svg>'
        : '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/></svg>';

    content.appendChild(icon);

    // Add message
    const text = document.createElement('p');
    text.textContent = message;
    content.appendChild(text);

    notification.appendChild(content);

    // Add close button
    const closeBtn = document.createElement('button');
    closeBtn.className = 'notification-close';
    closeBtn.innerHTML = '×';
    closeBtn.onclick = () => {
        notification.classList.add('fade-out');
        setTimeout(() => notification.remove(), 300);
    };
    notification.appendChild(closeBtn);

    // Add to container
    container.appendChild(notification);

    // Remove after 5 seconds
    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => notification.remove(), 300);
    }, 5000);
}

document.addEventListener('DOMContentLoaded', function() {
    // Get the form and form elements
    const contactForm = document.getElementById('contactForm');
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const subjectInput = document.getElementById('subject');
    const messageInput = document.getElementById('message');

    // Validation patterns
    const patterns = {
        name: /^[a-zA-Z\s]{2,50}$/,
        email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
        subject: /^.{2,100}$/,
        message: /^[\s\S]{10,1000}$/
    };

    // Error messages
    const errorMessages = {
        name: 'Name must be 2-50 characters long and contain only letters',
        email: 'Please enter a valid email address',
        subject: 'Subject must be 2-100 characters long',
        message: 'Message must be 10-1000 characters long'
    };

    // Add error styling to form field
    function showError(input, message) {
        const formGroup = input.parentElement;
        formGroup.classList.add('error');

        if (!formGroup.querySelector('.error-message')) {
            const error = document.createElement('span');
            error.className = 'error-message';
            error.textContent = message;
            formGroup.appendChild(error);
        }
    }

    // Remove error styling
    function removeError(input) {
        const formGroup = input.parentElement;
        formGroup.classList.remove('error');

        const error = formGroup.querySelector('.error-message');
        if (error) {
            error.remove();
        }
    }

    // Validate single input
    function validateInput(input, pattern, message) {
        if (!pattern.test(input.value.trim())) {
            showError(input, message);
            return false;
        }
        removeError(input);
        return true;
    }

    // Add input event listeners for real-time validation
    nameInput.addEventListener('input', () => {
        validateInput(nameInput, patterns.name, errorMessages.name);
    });

    emailInput.addEventListener('input', () => {
        validateInput(emailInput, patterns.email, errorMessages.email);
    });

    subjectInput.addEventListener('input', () => {
        validateInput(subjectInput, patterns.subject, errorMessages.subject);
    });

    messageInput.addEventListener('input', () => {
        validateInput(messageInput, patterns.message, errorMessages.message);
    });

    // Handle form submission
    contactForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        // Validate all inputs
        const isNameValid = validateInput(nameInput, patterns.name, errorMessages.name);
        const isEmailValid = validateInput(emailInput, patterns.email, errorMessages.email);
        const isSubjectValid = validateInput(subjectInput, patterns.subject, errorMessages.subject);
        const isMessageValid = validateInput(messageInput, patterns.message, errorMessages.message);

        // If all inputs are valid, submit the form
        if (isNameValid && isEmailValid && isSubjectValid && isMessageValid) {
            const submitButton = contactForm.querySelector('button[type="submit"]');
            submitButton.disabled = true;
            submitButton.innerHTML = 'Sending...';

            try {
                const formData = {
                    name: nameInput.value.trim(),
                    email: emailInput.value.trim(),
                    subject: subjectInput.value.trim(),
                    message: messageInput.value.trim()
                };

                // Simulate submission
                await new Promise(resolve => setTimeout(resolve, 1000));

                // Clear form
                contactForm.reset();
                createNotification('Message sent successfully!', 'success');

            } catch (error) {
                createNotification('Failed to send message. Please try again.', 'error');
            } finally {
                submitButton.disabled = false;
                submitButton.innerHTML = `
                    Send Message
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.002.26.41a.5.5 0 0 0 .886-.083l6-15Zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471-.47 1.178Z"/>
                    </svg>
                `;
            }
        }
    });
});
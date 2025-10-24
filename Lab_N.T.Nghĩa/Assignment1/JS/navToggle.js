const navToggle = document.getElementById('navToggle');
const navMenu = document.getElementById('navMenu');
const navLinks = document.querySelectorAll('.nav-link');

// Toggle menu for mobile
navToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
});

// Close menu when a link is clicked on mobile
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        navMenu.classList.remove('active');
    });
});

// Set initial tabindex and add keyboard navigation
document.addEventListener('DOMContentLoaded', function() {
    // Set initial tabindex for nav links
    navLinks.forEach(link => {
        link.setAttribute('tabindex', '0');
    });

    // Global keyboard shortcut for Home
    document.addEventListener('keydown', (e) => {
        if (e.key.toLowerCase() === 'h' &&
            document.activeElement.tagName !== 'INPUT' &&
            document.activeElement.tagName !== 'TEXTAREA') {
            e.preventDefault();
            window.location.href = '../index.html';
        }
    });

    // Navigation keyboard handlers
    navMenu.addEventListener('keydown', (e) => {
        const currentLink = document.activeElement;
        const links = Array.from(navLinks);
        const currentIndex = links.indexOf(currentLink);

        switch(e.key) {
            case 'ArrowRight':
            case 'ArrowDown':
                e.preventDefault();
                if (currentIndex < links.length - 1) {
                    links[currentIndex + 1].focus();
                } else {
                    links[0].focus();
                }
                break;

            case 'ArrowLeft':
            case 'ArrowUp':
                e.preventDefault();
                if (currentIndex > 0) {
                    links[currentIndex - 1].focus();
                } else {
                    links[links.length - 1].focus();
                }
                break;
        }
    });
});

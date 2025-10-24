// ============================================
// SMOOTH SCROLL BEHAVIOR
// ============================================
const navLinks = document.querySelectorAll('a[href^="#"]');

document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// ============================================
// INTERSECTION OBSERVER FOR ANIMATIONS
// ============================================

const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe project cards and testimonial cards
document.querySelectorAll('.project-card, .testimonial-card, .stat-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
    observer.observe(el);
});

// ============================================
// SKILL BARS ANIMATION
// ============================================

const skillBarsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const skillProgress = entry.target.querySelector('.skill-progress');
            if (skillProgress && !skillProgress.classList.contains('animated')) {
                skillProgress.classList.add('animated');
                skillBarsObserver.unobserve(entry.target);
            }
        }
    });
}, { threshold: 0.5 });

document.querySelectorAll('.skill-bar').forEach(bar => {
    skillBarsObserver.observe(bar);
});

// ============================================
// NAVBAR SCROLL EFFECT
// ============================================

let lastScrollTop = 0;
const navbar = document.querySelector('#navbar'); // fixed selector

window.addEventListener('scroll', () => {
    let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (navbar) {
        if (scrollTop > 100) {
            navbar.style.boxShadow = '0 2px 20px rgba(102, 252, 241, 0.1)';
        } else {
            navbar.style.boxShadow = 'none';
        }
    }

    lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
});

// ============================================
// PARALLAX EFFECT
// ============================================
const hero = document.querySelector('#home'); // matches index.html

window.addEventListener('scroll', () => {
    const scrollPosition = window.pageYOffset;

    if (hero && scrollPosition < window.innerHeight) {
        hero.style.backgroundPosition = `0 ${scrollPosition * 0.5}px`;
    }
});

// ============================================
// ACTIVE NAV LINK
// ============================================

window.addEventListener('scroll', () => {
    let current = '';
    const sections = document.querySelectorAll('section');

    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        if (pageYOffset >= sectionTop - 200) {
            current = section.getAttribute('id');
        }
    });

    if (navLinks && navLinks.length) {
        navLinks.forEach(link => {
            link.classList.remove('active');
            const href = link.getAttribute('href') || '';
            if (href.startsWith('#') && href.slice(1) === current) {
                link.classList.add('active');
            }
        });
    }
});

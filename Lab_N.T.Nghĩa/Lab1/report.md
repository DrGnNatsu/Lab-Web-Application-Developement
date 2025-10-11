# Submission Checklist:
## Semantically correct HTML structure.

**What?** Semantic HTML structure uses HTML5 elements that provide meaning and context to content rather than just presentation.

**Why?** Semantic elements improve accessibility for screen readers, enhance SEO by helping search engines understand content hierarchy, and make code more maintainable and readable for developers.

**How?** The implementation uses proper HTML5 semantic elements throughout the document structure:

```html
<header>
    <h1>Your Name</h1>
    <address>
        <p>123 Your Street</p>
        <a href="mailto:no_reply@example.com">no_reply@example.com</a>
    </address>
</header>
<main>
    <section id="education">
        <article>
            <time>Month 20xx - Month 20xx</time>
        </article>
    </section>
</main>
```

The structure uses header/main/footer for layout, section/article for content organization, address for contact info, and time elements for dates.

## Single-page layout with sections for education, skills, and career history.

**What?** A single-page layout contains all CV content within one HTML document organized into distinct sections without requiring navigation between pages.

**Why?** This design provides immediate access to all information, improves user experience by eliminating page loads, and creates a cohesive presentation suitable for both digital viewing and printing.

**How?** The layout implements three main content sections within a structured HTML document:

```html
<main>
    <section id="education">
        <h2>Education</h2>
        <article>
            <h3>School Name, Location - Degree</h3>
        </article>
    </section>
    <section id="skills">
        <h2>Skills</h2>
        <p>HTML, CSS, JavaScript, Accessibility...</p>
    </section>
    <section id="experience">
        <h2>Experience</h2>
        <article>
            <h3>Company Name, Location - Job Title</h3>
        </article>
    </section>
</main>
```

Each section uses semantic elements and consistent styling to create a professional, scannable CV format.

## SEO meta tags in the head section.

**What?** SEO meta tags are HTML elements in the head section that provide structured information about the webpage to search engines and browsers.

**Why?** These tags improve search engine rankings by helping crawlers understand page content, display attractive snippets in search results, and categorize the website properly. They enhance discoverability and click-through rates from search engine results pages.

**How?** The implementation uses four essential meta tags within the HTML head section:

```html
<meta name="description" content="Professional CV of a Junior Frontend Developer showcasing education, skills, and experience in web development.">
<meta name="keywords" content="frontend developer, web development, HTML, CSS, JavaScript, CV, resume">
<meta name="author" content="Your Name">
<meta name="robots" content="index, follow">
```

The description tag provides search result snippets, keywords help with content classification, author identifies the creator, and robots directs search engine behavior.

## OG tags for better social media sharing.

**What?** Open Graph (OG) tags are meta tags that control how content appears when shared on social media platforms like Facebook, LinkedIn, and Twitter.

**Why?** These tags ensure consistent, attractive presentation when the webpage is shared, displaying custom titles, descriptions, and images instead of default auto-generated content. They significantly improve click-through rates and professional appearance on social platforms.

**How?** The implementation includes essential OG properties and Twitter Card tags in the head section:

```html
<meta property="og:title" content="Your Name - Junior Frontend Developer CV">
<meta property="og:description" content="Professional CV showcasing education, skills, and experience in web development.">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Your Name CV">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Your Name - Junior Frontend Developer CV">
```

These tags control the title, description, content type, and site name displayed when shared on social media platforms.

## A favicon linked in the head section.

**What?** A favicon is a small icon displayed in browser tabs, bookmarks, and browser interfaces to visually identify the website.

**Why?** Favicons enhance brand recognition, improve user experience by making the site easily identifiable among multiple tabs, and provide professional appearance. They also appear in bookmarks and browser history for better visual navigation.

**How?** Multiple favicon formats are implemented to ensure compatibility across different devices and browsers:

```html
<link rel="icon" href="./public/favicon_io/favicon.ico" type="image/x-icon">
<link rel="icon" href="./public/favicon_io/favicon-16x16.png" sizes="16x16" type="image/png">
<link rel="icon" href="./public/favicon_io/favicon-32x32.png" sizes="32x32" type="image/png">
<link rel="apple-touch-icon" href="./public/favicon_io/apple-touch-icon.png">
```

The implementation includes standard .ico format, multiple PNG sizes for different display contexts, and Apple touch icon for iOS devices.

# Submission Checklist:
## Semantically correct HTML structure.

**What?** Semantic HTML structure uses HTML5 elements that provide meaning and context to content rather than just presentation.

**Why?** The purpose is to create accessible web content that assistive technologies can navigate properly. It ensures search engines understand the content structure for better rankings and makes the code maintainable for future development.

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

## Single-page layout with sections for education, skills, and career history.

**What?** A single-page layout contains all CV content within one HTML document organized into distinct sections without requiring navigation between pages.

**Why?** The purpose is to provide instant access to all CV information without requiring navigation between pages. This creates a seamless user experience and ensures the content works equally well for digital viewing and printing.

**How?** The layout implements three main content sections within a structured HTML document:

```html
<!DOCTYPE html>
<html lang="en">
<head>

</head>
<style>
</style>
<body>

</body>
</html>
```

## SEO meta tags in the head section.

**What?** SEO meta tags are HTML elements in the head section that provide structured information about the webpage to search engines and browsers.

**Why?** The purpose is to help search engines understand and properly index the webpage content for better visibility. These tags control how the page appears in search results to attract more visitors.

**How?** The implementation uses four essential meta tags within the HTML head section:

```html
<meta name="description" content="Professional CV of a Junior Frontend Developer showcasing education, skills, and experience in web development.">
<meta name="keywords" content="frontend developer, web development, HTML, CSS, JavaScript, CV, resume">
<meta name="author" content="Your Name">
<meta name="robots" content="index, follow">
```

## OG tags for better social media sharing.

**What?** Open Graph (OG) tags are meta tags that control how content appears when shared on social media platforms like Facebook, LinkedIn, and Twitter.

**Why?** The purpose is to control how the webpage appears when shared on social media platforms with custom titles and descriptions. This ensures professional presentation and increases the likelihood of engagement when shared.

**How?** The implementation includes essential OG properties and Twitter Card tags in the head section:

```html
<meta property="og:title" content="Your Name - Junior Frontend Developer CV">
<meta property="og:description" content="Professional CV showcasing education, skills, and experience in web development.">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Your Name CV">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Your Name - Junior Frontend Developer CV">
```
## A favicon linked in the head section.

**What?** A favicon is a small icon displayed in browser tabs, bookmarks, and browser interfaces to visually identify the website.

**Why?** The purpose is to provide visual identification of the website in browser tabs, bookmarks, and browser interfaces. This creates a professional appearance and helps users quickly locate the site among multiple open tabs.

**How?** Multiple favicon formats are implemented to ensure compatibility across different devices and browsers:

```html
<link rel="icon" href="./public/favicon_io/favicon.ico" type="image/x-icon">
<link rel="icon" href="./public/favicon_io/favicon-16x16.png" sizes="16x16" type="image/png">
<link rel="icon" href="./public/favicon_io/favicon-32x32.png" sizes="32x32" type="image/png">
<link rel="apple-touch-icon" href="./public/favicon_io/apple-touch-icon.png">
```
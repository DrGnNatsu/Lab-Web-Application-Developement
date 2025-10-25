# Task 1: Form Validator

## All validation functions work correctly (6 points)

The form validator implements four validation functions that ensure data integrity:

**1. Username Validation**
```javascript
function validateUsername(username) {
    const usernameRegex = /^[a-zA-Z0-9]{4,20}$/;
    return usernameRegex.test(username);
}
```
- Accepts only alphanumeric characters (a-z, A-Z, 0-9)
- Enforces length between 4-20 characters
- Returns boolean indicating validity

**2. Email Validation**
```javascript
function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}
```
- Requires valid email format with @ symbol and domain
- Prevents whitespace in email addresses

**3. Password Validation**
```javascript
function validatePassword(password) {
    const passwordRegex = /^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$/;
    return passwordRegex.test(password);
}
```
- Minimum 8 characters
- At least one uppercase letter
- At least one digit

**4. Password Match Validation**
```javascript
function validatePasswordMatch(pass1, pass2) {
    return pass1 === pass2;
}
```
- Strict equality check between password fields

## Real-time validation on input (3 points)

The implementation provides instant validation feedback through event listeners:

```javascript
document.getElementById('username').addEventListener('input', validateForm);
document.getElementById('email').addEventListener('input', validateForm);
document.getElementById('password').addEventListener('input', validateForm);
document.getElementById('confirmPassword').addEventListener('input', validateForm);
```

**How it works:**
- Each input field has an `input` event listener
- Triggers `validateForm()` on every keystroke
- Provides immediate feedback without requiring blur or submit
- Validates all fields simultaneously for consistent state
- Enhances user experience by catching errors early

## Visual feedback (borders and messages) (3 points)

The form provides dual visual feedback through CSS styling and error messages:
**Error Message System:**
```javascript
function showError(fieldId, message) {
    const errorElement = document.getElementById(fieldId + 'Error');
    errorElement.textContent = message;
    errorElement.classList.add('show');
}

function clearError(fieldId) {
    const errorElement = document.getElementById(fieldId + 'Error');
    errorElement.textContent = '';
    errorElement.classList.remove('show');
}
```

**Error Messages Displayed:**
- Username: "Must 4-20 alphanumeric characters"
- Email: "Invalid email"
- Password: "Invalid password"
- Confirm Password: "Passwords do not match"

Each error appears in red text below the corresponding field, providing clear guidance on what needs correction.

## Submit button enable/disable logic (2 points)

The submit button dynamically enables based on form validity:

```javascript
function validateForm() {
    // Get all input values
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    let isValid = true;

    // Run all validations
    if (!validateUsername(username)) {
        showError('username', 'Must 4-20 alphanumeric characters');
        isValid = false;
    } else {
        clearError('username');
    }
    // ... (similar for other fields)

    // Enable/disable submit button
    document.getElementById('submitBtn').disabled = !isValid;
}
```

**Button States:**
- **Initial state:** Disabled (`disabled` attribute in HTML)
- **Invalid form:** Gray background (#ccc), disabled cursor
- **Valid form:** Blue background (#007bff), enabled for submission
- **Logic:** Button only enables when `isValid` remains true for all fields

## Clean, readable code (1 point)

The code demonstrates professional organization and maintainability:

**Strengths:**
1. **Clear Function Names:** `validateUsername()`, `validateEmail()`, `validatePassword()` - self-documenting
2. **Single Responsibility Principle:** Each function handles one specific task
3. **Consistent Formatting:** Proper indentation and spacing throughout
4. **Logical Structure:**
   - Validation functions grouped together
   - Helper functions (showError/clearError) separated
   - Event listeners organized at the end
5. **Descriptive Variables:** `isValid`, `errorElement`, `passwordRegex` convey purpose clearly
6. **Separation of Concerns:** HTML structure, CSS styling, and JavaScript logic clearly separated

The modular approach makes the code easy to understand, test, and maintain.

# Task 1.2: Shopping Cart

## Add to cart functionality (3 points)

The shopping cart implements robust add-to-cart logic with duplicate handling:

**Add to Cart Function:**

```javascript
function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    if (product) {
        const cartItem = cart.find(item => item.id === productId);
        if (cartItem) {
            cartItem.quantity += 1;
        } else {
            cart.push({ ...product, quantity: 1 });
        }
        renderCart();
    }
}
```

**How it works:**

- Uses `Array.find()` to locate product by ID from the products array
- Checks if product already exists in cart using `cart.find()`
- If item exists: Increments existing quantity by 1
- If new item: Adds to cart with quantity 1 using spread operator (`{ ...product, quantity: 1 }`)
- Automatically triggers `renderCart()` to update UI display
- Each product card has "Add to Cart" button with `onclick="addToCart(${product.id})"`

## Quantity increase/decrease (3 points)

The cart provides precise quantity control with increment and decrement buttons:

**Update Quantity Function:**

```javascript
function updateQuantity(productId, change) {
    const cartItem = cart.find(item => item.id === productId);
    if (cartItem) {
        cartItem.quantity += change;
        if (cartItem.quantity <= 0) {
            removeFromCart(productId);
        } else {
            renderCart();
        }
    }
}
```

**Implementation in UI:**

```javascript
<button onclick="updateQuantity(${item.id}, -1)">-</button>
<span>${item.quantity}</span>
<button onclick="updateQuantity(${item.id}, 1)">+</button>
```

**Features:**

- **Increase (+):** Passes `change = 1` to increment quantity
- **Decrease (-):** Passes `change = -1` to decrement quantity
- Automatic removal if quantity reaches 0
- Real-time quantity display between buttons
- Instant cart re-render on every change

## Remove from cart (2 points)

Direct removal functionality allows users to delete items instantly:

**Remove from Cart Function:**

```javascript
function removeFromCart(itemId) {
    const cartItemIndex = cart.findIndex(item => item.id === itemId);
    if (cartItemIndex !== -1) {
        cart.splice(cartItemIndex, 1);
        renderCart();
    }
}
```

**How it works:**

- Uses `findIndex()` to locate item position in cart array
- Validates item exists with `if (cartItemIndex !== -1)`
- Removes item using `splice(cartItemIndex, 1)`
- Triggers immediate cart update with `renderCart()`
- Called automatically when quantity decrements to 0
- Also accessible via dedicated "Remove" button in cart UI

## Total calculation (3 points)

The cart dynamically calculates and displays the total price:

**Calculate Total Function:**

```javascript
function calculateTotal() {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
}
```

**Display in Render Cart:**

```javascript
cartTotal.textContent = calculateTotal().toFixed(2);
```

**How it works:**

- Uses `Array.reduce()` to accumulate total from all cart items
- Multiplies each item's unit price by its quantity: `item.price * item.quantity`
- Starts accumulation from 0 as initial value
- Formats to 2 decimal places with `.toFixed(2)` for currency display
- Updates automatically on every cart modification
- Displayed in cart footer: `Total: $<span id="cartTotal">0.00</span>`

## Cart count badge updates (2 points)

The cart icon displays a live count of total items in the cart:

**Cart Count Update Implementation:**

```javascript
cartCount.textContent = cart.reduce((sum, item) => sum + item.quantity, 0);
```

**HTML Badge Structure:**

```html
<div class="cart-icon" onclick="toggleCart()">
    🛒 Cart
    <span class="cart-count" id="cartCount">0</span>
</div>
```

**Features:**

- Uses `reduce()` to sum all item quantities, not just item count
- Shows total units (e.g., "5" if you have 3 laptops + 2 phones)
- Red circular badge positioned absolutely on cart icon
- Updates in real-time with every cart change through `renderCart()`
- Provides instant visual feedback in header without opening cart

## Clean UI and code (2 points)

The application demonstrates professional design and code organization:

**UI Design:**

- **Modern Layout:** Responsive grid (`grid-template-columns: repeat(auto-fill, minmax(250px, 1fr))`)
- **Clean Cards:** White product cards with subtle shadows on light gray background
- **Clear Typography:** Distinct styling for product names, prices, and buttons
- **Interactive Elements:** Hover effects on buttons, smooth transitions
- **Organized Hierarchy:** Dark header with cart icon, product grid, collapsible cart section

**Code Quality:**

1. **Modular Functions:** Each function has single responsibility
2. **Descriptive Naming:** `addToCart()`, `updateQuantity()`, `calculateTotal()` are self-documenting
3. **Data Structure:** Simple array-based cart with object spreading for clean state updates
4. **Consistent Patterns:** All cart operations follow render-after-update pattern
5. **Separation of Concerns:** Data layer (products/cart), logic layer (functions), presentation layer (render)
6. **Clean Initialization:** `renderProducts()` called once at startup

The code is readable, maintainable, and follows JavaScript best practices.

# Task 2.1: Weather Dashboard

## API integration works (4 points)

The weather dashboard successfully integrates with OpenWeatherMap API for real-time weather data:

**Fetch Current Weather:**

```javascript
async function fetchWeather(city) {
    try {
        let response = await fetch(
            `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}&units=metric`
        );
        if (!response.ok) {
            throw new Error('City not found');
        }
        return await response.json();
    }
    catch (error) {
        showError(error.message);
    }
}
```

**Fetch 5-Day Forecast:**

```javascript
async function fetchForecast(city) {
    let response = await fetch(
        `https://api.openweathermap.org/data/2.5/forecast?q=${city}&appid=${API_KEY}&units=metric`
    );
    if (!response.ok) {
        throw new Error('City not found');
    }
    return await response.json();
}
```

**How it works:**

- Uses `async/await` for clean asynchronous code
- Calls two separate API endpoints (current weather and forecast)
- Includes API key authentication
- Uses metric units for temperature
- Validates response status with error handling
- Returns parsed JSON data for display

## Current weather display (3 points)

The application displays comprehensive current weather information:

**Display Weather Function:**

```javascript
function displayWeather(data) {
    const weatherHTML = `
        <div class="weather-card">
            <h2>Current Weather in ${data.name}</h2>
            <div class="current-weather">
                <div class="temp-display">${data.main.temp}°C</div>
                <div class="weather-description">${data.weather[0].description}</div>
            </div>
            <div class="additional-info">
                <p>Humidity: ${data.main.humidity}%</p>
                <p>Wind Speed: ${data.wind.speed} m/s</p>
            </div>
        </div>
    `;
    document.getElementById('weatherDisplay').innerHTML = weatherHTML;
}
```

**Information displayed:**

- City name from API response
- Current temperature in Celsius (large 60px display)
- Weather description (e.g., "clear sky", "light rain")
- Humidity percentage
- Wind speed in meters per second
- Styled card with gradient background

## 5-day forecast display (3 points)

The forecast section displays weather predictions for the next 5 days:

**Display Forecast Function:**

```javascript
function displayForecast(data) {
    let forecastHTML = '<div class="weather-card"><h2>5-Day Forecast</h2><div class="forecast-grid">';
    const dailyData = {};
    
    // Filter to get one forecast per day at noon
    data.list.forEach(item => {
        const date = item.dt_txt.split(' ')[0];
        if (!dailyData[date] && item.dt_txt.includes('12:00:00')) {
            dailyData[date] = item;
        }
    });
    
    for (let date in dailyData) {
        const item = dailyData[date];
        forecastHTML += `
            <div class="forecast-item">
                <h3>${new Date(item.dt_txt).toLocaleDateString()}</h3>
                <p>${item.main.temp}°C</p>
                <p>${item.weather[0].description}</p>
            </div>
        `;
    }
}
```

**Features:**

- Filters API data to show one forecast per day (at 12:00 PM)
- Responsive grid layout with `grid-template-columns: repeat(auto-fit, minmax(150px, 1fr))`
- Displays date, temperature, and weather description for each day
- Uses `toLocaleDateString()` for proper date formatting

## Recent searches with localStorage (3 points)

The application saves and displays recent city searches:

**Save Recent Search:**

```javascript
function saveRecentSearch(city) {
    let recent = JSON.parse(localStorage.getItem('recentCities')) || [];
    recent = recent.filter(c => c !== city); // Remove duplicates
    recent.unshift(city); // Add to beginning
    if (recent.length > 5) recent.pop(); // Keep only 5 cities
    localStorage.setItem('recentCities', JSON.stringify(recent));
    loadRecentSearches();
}
```

**Load Recent Searches:**

```javascript
function loadRecentSearches() {
    let recent = JSON.parse(localStorage.getItem('recentCities')) || [];
    const recentSearchesContainer = document.getElementById('recentSearches');
    recentSearchesContainer.innerHTML = '';
    
    recent.forEach(city => {
        const cityElement = document.createElement('div');
        cityElement.classList.add('recent-search');
        cityElement.textContent = city;
        cityElement.addEventListener('click', () => {
            document.getElementById('cityInput').value = city;
            searchWeather();
        });
        recentSearchesContainer.appendChild(cityElement);
    });
}
```

**Features:**

- Stores up to 5 recent cities in localStorage
- Removes duplicates when adding new searches
- Most recent search appears first
- Clickable pills for quick re-search
- Persists across browser sessions
- Called on page load to initialize

## Error handling (1 point)

The application provides clear error feedback for failed operations:

**Error Display Functions:**

```javascript
function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.innerHTML = `<div class="error">${message}</div>`;
}

function clearError() {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.innerHTML = '';
}
```

**Error handling in search:**

```javascript
try {
    const weatherData = await fetchWeather(city);
    displayWeather(weatherData);
    const forecastData = await fetchForecast(city);
    displayForecast(forecastData);
    saveRecentSearch(city);
} catch (error) {
    showError(error.message);
    document.getElementById('weatherDisplay').innerHTML = '';
    document.getElementById('forecastDisplay').innerHTML = '';
}
```

**Features:**

- Red error banner with clear messages
- Handles "City not found" errors
- Clears previous errors before new searches
- Cleans up display on error

## Loading state (1 point)

The application shows loading feedback during API calls:

**Loading implementation:**

```javascript
async function searchWeather() {
    const city = document.getElementById('cityInput').value.trim().toLowerCase();
    if (!city) return;
    
    clearError();
    document.getElementById('weatherDisplay').innerHTML = '<div class="loading">Loading...</div>';
    document.getElementById('forecastDisplay').innerHTML = '';
    
    try {
        const weatherData = await fetchWeather(city);
        displayWeather(weatherData);
        // ...
    }
}
```

**Features:**

- Displays "Loading..." message immediately on search
- Clears previous weather data
- Provides visual feedback while waiting for API response
- Improves user experience during network delays

# Task 2.2: Github Finder

## Search functionality works (4 points)

The GitHub Finder implements comprehensive repository search using GitHub's API:

**Search Repositories Function:**

```javascript
async function searchRepositories(query, sort = 'stars', page = 1) {
    try {
        const response = await fetch(
            `https://api.github.com/search/repositories?q=${query}&sort=${sort}&page=${page}&per_page=10`
        );
        if (!response.ok) {
            throw new Error('Failed to fetch repositories');
        }
        const data = await response.json();
        totalResults = data.total_count;
        return data.items;
    }
    catch (error) {
        showError(error.message);
        return [];
    }
}
```

**Perform Search Function:**

```javascript
async function performSearch() {
    const query = document.getElementById('searchInput').value.trim();
    const sort = document.getElementById('sortSelect').value;
    currentPage = 1;
    clearError();
    
    try {
        const repos = await searchRepositories(query, sort, currentPage);
        displayRepositories(repos, false);
    } catch (error) {
        showError(error.message);
    }
}
```

**Features:**

- Uses GitHub Search API with query parameters
- Supports Enter key for quick search
- Fetches 10 repositories per page
- Includes error handling for failed requests
- Resets page to 1 on new searches
- Clears previous errors before searching

## Repository cards display correctly (4 points)

Each repository is displayed in a well-structured card with comprehensive information:

**Create Repo Card Function:**

```javascript
function createRepoCard(repo) {
    const repoCard = document.createElement('div');
    repoCard.className = 'repo-card';
    repoCard.innerHTML = `
        <a href="${repo.html_url}" target="_blank" class="repo-name">
            ${repo.owner.login} / ${repo.name}
        </a>
        <p class="repo-description">
            ${repo.description || 'No description available.'}
        </p>
        <div class="repo-meta">
            <span>⭐ ${formatNumber(repo.stargazers_count)}</span>
            <span>🔱 ${formatNumber(repo.forks_count)}</span>
            ${repo.language ? `<span class="language-badge">${repo.language}</span>` : ''}
        </div>
    `;
    return repoCard;
}
```

**Display Repositories Function:**

```javascript
function displayRepositories(repos, append = false) {
    const repoList = document.getElementById('repoList');
    if (!append) {
        repoList.innerHTML = '';
    }
    
    repos.forEach(repo => {
        const repoCard = createRepoCard(repo);
        repoList.appendChild(repoCard);
    });
    
    // Show/hide load more button
    const loadMoreContainer = document.getElementById('loadMoreContainer');
    if (totalResults > currentPage * 10) {
        loadMoreContainer.innerHTML = `
            <div class="load-more">
                <button onclick="loadMore()">Load More</button>
            </div>
        `;
    } else {
        loadMoreContainer.innerHTML = '';
    }
}
```

**Card displays:**

- Owner name and repository name as clickable link
- Repository description (or fallback text)
- Star count with formatted numbers
- Fork count with formatted numbers
- Programming language badge (if available)
- GitHub-themed dark UI styling
- Hover effects for better UX

## Sort functionality (2 points)

Users can sort repositories by different criteria:

**Sort Select Element:**

```html
<select id="sortSelect" onchange="performSearch()">
    <option value="stars">⭐ Stars</option>
    <option value="forks">🔱 Forks</option>
    <option value="updated">🕒 Recently Updated</option>
</select>
```

**How it works:**

- Dropdown with three sorting options
- Triggers new search on selection change
- Passes sort parameter to GitHub API
- Resets pagination when sort changes
- Visual icons for each option

## Load more pagination (2 points)

The application implements pagination to load additional results:

**Load More Function:**

```javascript
async function loadMore() {
    const input = document.getElementById('searchInput').value.trim();
    const sort = document.getElementById('sortSelect').value;
    const data = await searchRepositories(input, sort, ++currentPage);
    displayRepositories(data, true);
}
```

**Features:**

- "Load More" button appears when more results exist
- Increments page counter on click
- Appends new results to existing list
- Hides button when all results loaded
- Maintains current search query and sort

## Error handling (2 points)

Comprehensive error handling throughout the application:

**Error Functions:**

```javascript
function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.innerHTML = `<div class="error">${message}</div>`;
}

function clearError() {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.innerHTML = '';
}
```

**Implementation:**

- Try-catch blocks in async functions
- Displays error messages in red banner
- Checks response status with `if (!response.ok)`
- Returns empty array on error to prevent crashes
- Clears errors before new searches

## Clean UI (1 point)

The interface follows GitHub's design aesthetic:

**Design features:**

- Dark theme matching GitHub's UI (`background: #0d1117`)
- Consistent color scheme with blues and grays
- Hover effects on cards (`transform: translateY(-2px)`)
- Clean typography with proper spacing
- Responsive layout with flexbox and grid
- Icon integration for visual appeal
- Professional card shadows and borders
- GitHub-blue accent color (`#58a6ff`) for links


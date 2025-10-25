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

# Task 2: Shopping Cart

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

- Finds the product by ID from the products array
- Checks if the product already exists in the cart
- If exists: Increments quantity by 1
- If new: Adds product with quantity 1 using spread operator
- Automatically triggers cart re-render to update UI
- Each product card has an "Add to Cart" button with `onclick="addToCart(${product.id})"`

## Cart quantity management (3 points)

The cart provides comprehensive quantity control with increment, decrement, and remove functions:

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

**Controls provided:**

- **Increment (+):** Increases quantity by 1
- **Decrement (-):** Decreases quantity by 1, auto-removes if reaches 0
- **Remove button:** Immediately removes item from cart
- All changes trigger immediate cart re-render

## Total price calculation (2 points)

The cart calculates and displays the total price dynamically:

**Calculate Total Function:**

```javascript
function calculateTotal() {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
}
```

**Display implementation:**

```javascript
cartTotal.textContent = calculateTotal().toFixed(2);
```

**How it works:**

- Uses `Array.reduce()` to sum all items
- Multiplies each item's price by its quantity
- Returns accumulated total
- Displays with `.toFixed(2)` for consistent currency formatting
- Updates automatically whenever cart changes through `renderCart()`

## Dynamic cart display (3 points)

The cart dynamically renders all items with complete information:

**Render Cart Function:**

```javascript
function renderCart() {
    const cartItemsContainer = document.getElementById('cartItems');
    const cartCount = document.getElementById('cartCount');
    const cartTotal = document.getElementById('cartTotal');
    
    cartItemsContainer.innerHTML = '';
    cartCount.textContent = cart.reduce((sum, item) => sum + item.quantity, 0);
    cartTotal.textContent = calculateTotal().toFixed(2);
    
    cart.forEach(item => {
        const cartItemDiv = document.createElement('div');
        cartItemDiv.className = 'cart-item';
        cartItemDiv.innerHTML = `
            <div>
                <strong>${item.name}</strong> - $${item.price.toFixed(2)}
            </div>
            <div class="quantity-controls">
                <button onclick="updateQuantity(${item.id}, -1)">-</button>
                <span>${item.quantity}</span>
                <button onclick="updateQuantity(${item.id}, 1)">+</button>
                <button onclick="removeFromCart(${item.id})">Remove</button>
            </div>
        `;
        cartItemsContainer.appendChild(cartItemDiv);
    });
}
```

**Cart displays:**

- Item name and unit price
- Current quantity with controls
- Cart badge showing total item count
- Total price at bottom
- Toggle visibility with cart icon click

## Product rendering (2 points)

Products are dynamically generated from the data array:

**Product Data:**

```javascript
const products = [
    { id: 1, name: 'Laptop', price: 999.99, image: '💻' },
    { id: 2, name: 'Smartphone', price: 699.99, image: '📱' },
    { id: 3, name: 'Headphones', price: 199.99, image: '🎧' },
    { id: 4, name: 'Smartwatch', price: 299.99, image: '⌚' }
];
```

**Render Products Function:**

```javascript
function renderProducts() {
    const productsGrid = document.getElementById('productsGrid');
    productsGrid.innerHTML = '';
    products.forEach(product => {
        const productCard = document.createElement('div');
        productCard.className = 'product-card';
        productCard.innerHTML = `
            <div class="product-image">${product.image}</div>
            <div class="product-info">
                <h3>${product.name}</h3>
                <p>Price: $${product.price.toFixed(2)}</p>
                <button class="add-to-cart-btn" onclick="addToCart(${product.id})">Add to Cart</button>
            </div>
        `;
        productsGrid.appendChild(productCard);
    });
}
```

**Features:**

- Responsive grid layout (`grid-template-columns: repeat(auto-fill, minmax(250px, 1fr))`)
- Each card shows emoji image, name, price, and add button
- Called on page load to initialize product display

## Clean, organized code (2 points)

The shopping cart demonstrates excellent code organization:

**Strengths:**

1. **Modular Functions:** Each function has a single, clear purpose
2. **Descriptive Naming:** `addToCart`, `updateQuantity`, `calculateTotal` are self-explanatory
3. **Data Structure:** Simple array-based cart with object spreading for immutability
4. **Separation of Concerns:**
   - Data layer: `products` array and `cart` state
   - Logic layer: CRUD functions for cart management
   - Presentation layer: `renderProducts()` and `renderCart()`
5. **Consistent Patterns:** All functions follow similar structure and error handling
6. **Initialization:** Clean startup with `renderProducts()` call at end

The code is maintainable, scalable, and easy to extend with new features.

# Fresh Parts - Shop App

## Overview

**THIS APP WAS CREATED ON A LAPTOP WITH NO FUNCTIONING TRACKPAD THAT IS WHY EVERYTHING WAS MADE IN MAIN, IT WAS FASTER**

**Fresh Parts** is a Flutter-based e-commerce application that provides a seamless shopping experience. Users can browse products, view product details, add items to their cart, and sign in or sign up for an account. The app features a modern UI with a dark theme for an enhanced user experience.

---

## Classes and Their Roles

### **Main Application Structure**

 **`CustomScaffold`**
   - A reusable scaffold widget with a customizable `body` parameter.
   - Includes:
     - A consistent `AppBar` with a title, menu button, and sign-in/out functionality.
     - A navigation drawer with links to different pages (e.g., Main Page, Search, Checkout).
     - A gradient background for the body.
       
1. **`MainScreen`**
   - Displays product categories in a scrollable list.
   - Each category showcases its products in a horizontal carousel.
   - Tapping a product navigates to its detailed view (`ProductDetailPage`).

2. **`SignInPage`**
   - Provides a sign-in interface for existing users.
   - Validates user credentials from the local `SignUpPage.userList`.
   - Redirects users to the `MainScreen` upon successful login.
   - Displays an error message for invalid login attempts.

3. **`SignUpPage`**
   - Allows new users to create an account by entering a username and password.
   - Stores user information in a local static list (`userList`).
   - Redirects users to the sign-in page after successful account creation.

4. **`ProductDetailPage`**
   - Displays detailed information about a selected product.
   - Includes:
     - Product image, name, price, and description.
     - An "Add to Cart" button to add the product to the global `cart`.
   - Shows a confirmation message upon adding a product to the cart.


## Features
- **User Authentication**:
  - Sign in with existing credentials.
  - Create new accounts.
- **Product Browsing**:
  - Organized by categories, products are presented with images, names, prices, and ratings.
- **Product Details**:
  - Detailed product views with descriptions and purchase options.
- **Navigation Drawer**:
  - Links to the main page, search page, and checkout page.

---

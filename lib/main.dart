import 'dart:math';
import 'package:flutter/material.dart';

bool isLoggedIn = false;
final List<Product> cart = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[850],
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Updated from bodyText1
          bodyMedium: TextStyle(color: Colors.white), // Updated from bodyText2
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: MainScreen(),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final Widget body;

  const CustomScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOnSignInOrSignUpPage =
        body is SignInPage || body is SignUpPage;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fresh Parts'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          if (!isOnSignInOrSignUpPage)
            TextButton(
              onPressed: () {
                if (isLoggedIn) {
                  isLoggedIn = false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out successfully.')),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                        (route) => false,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                }
              },
              child: Text(
                isLoggedIn ? 'Log Out' : 'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[850]),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Main Page', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.search, color: Colors.white),
                title: Text('Search', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart_checkout, color: Colors.white),
                title: Text('Checkout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[900]!, Colors.grey[800]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: body,
      ),
    );
  }
}



class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: productCategories.entries.map((entry) {
            final categoryName = entry.key;
            final categoryProducts = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Product cards in the section
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categoryProducts.map((product) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  product.imagePath,
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    product.review,
                                        (index) => Icon(Icons.star, size: 14, color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}





class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  void _signIn() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    bool isValid = SignUpPage.userList.any(
          (user) => user['username'] == username && user['password'] == password,
    );

    if (isValid) {
      setState(() {
        _errorMessage = '';
        isLoggedIn = true; // Update global state
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, $username!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });

      _usernameController.clear();
      _passwordController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Need an account? Sign up here'),
            ),
          ],
        ),
      ),
    );
  }
}



class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Local storage for usernames and passwords
  static final List<Map<String, String>> userList = [];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create an account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;

                if (username.isNotEmpty && password.isNotEmpty) {
                  // Save the username and password to the local list
                  userList.add({'username': username, 'password': password});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign Up Successful!')),
                  );

                  Navigator.pop(context); // Return to the Sign In page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}



class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
            // Add a SizedBox to control spacing between content and button
            SizedBox(height: 100), // Adjust this value for further spacing
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add the product to the cart
                  cart.add(product);

                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} has been added to your cart!'),
                    ),
                  );
                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = [
    'Graphics Card',
    'Processor',
    'Motherboard',
    'Power Supply',
    'Prebuilt Desktop'
  ];

  Map<String, bool> selectedCategories = {};
  List<Product> filteredProducts = products; // Initial product list
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize selected categories as unchecked
    for (var category in categories) {
      selectedCategories[category] = false;
    }
  }

  // Update filtered products based on search query and selected categories
  void updateFilteredProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesQuery = product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.category.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory = selectedCategories.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .contains(product.category);

        return matchesQuery && (matchesCategory || selectedCategories.values.every((isChecked) => !isChecked));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                updateFilteredProducts();
              },
            ),
            SizedBox(height: 16),
            // Category filters
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: selectedCategories[category]!,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedCategories[category] = isSelected;
                      updateFilteredProducts();
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Results list
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  'No products found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(
                        product.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text(product.category),
                      trailing: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.green),
                      ),
                      onTap: () {
                        // Navigate to product detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Map<Product, int> cartItems = {};  // Assuming 'cart' is a predefined list

  @override
  void initState() {
    super.initState();
    // Initialize cart items grouped by quantity
    for (var product in cart) {
      cartItems[product] = (cartItems[product] ?? 0) + 1;
    }
  }

  // Calculate subtotal
  double calculateSubtotal() {
    double subtotal = 0.0;
    cartItems.forEach((product, quantity) {
      subtotal += product.price * quantity;
    });
    return subtotal;
  }

  // Calculate shipping (static)
  double calculateShipping() {
    if (cartItems.isEmpty) return 0; // No shipping cost if cart is empty

    bool containsDesktop = cartItems.keys.any((product) => product.category == 'Prebuilt Desktop');
    return containsDesktop ? 25.0 : 15.0; // Charge based on desktop presence
  }

  // Calculate total cost
  double calculateTotalCost() {
    double subtotal = calculateSubtotal();
    double tax = subtotal * 0.12; // 12% sales tax
    double shipping = calculateShipping();
    return subtotal + tax + shipping;
  }

  // Update quantity of a product
  void updateQuantity(Product product, int change) {
    setState(() {
      if (cartItems.containsKey(product)) {
        cartItems[product] = (cartItems[product]! + change).clamp(0, 100);
        if (cartItems[product] == 0) {
          cartItems.remove(product);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems.keys.elementAt(index);
                  final quantity = cartItems[product]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Quantity adjustment
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => updateQuantity(product, -1),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => updateQuantity(product, 1),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        // Product image
                        Image.asset(
                          product.imagePath,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        // Product name
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Product price
                        Text(
                          '\$${(product.price * quantity).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(),
            // Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subtotal: \$${calculateSubtotal().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Sales Tax (12%): \$${(calculateSubtotal() * 0.12).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Shipping: ${cartItems.isEmpty ? "----" : "\$${calculateShipping().toStringAsFixed(2)}"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total: \$${calculateTotalCost().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Proceed to payment button
            ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null  // Disable if cart is empty
                  : () {
                // Handle proceeding to payment and navigate to PaymentPage
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Proceeding to payment...')),
                );

                // Navigate to PaymentPage (pass the isLoggedIn flag)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(isLoggedIn: true), // Change true/false based on login status
                  ),
                );
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final bool isLoggedIn; // Pass whether the user is logged in or not

  const PaymentPage({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Form keys for validation
  final _paymentFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _cardNumberController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isProcessingPayment = false; // Flag for showing processing status
  String _paymentStatus = ''; // To store payment status

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Credit Card Info
              Form(
                key: _paymentFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Credit Card Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(labelText: 'Card Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your card number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _expirationDateController,
                      decoration: InputDecoration(labelText: 'Expiration Date (MM/YY)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiration date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(labelText: 'CVV'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // Address Info
              Form(
                key: _addressFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(labelText: 'Street Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: 'City'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: 'State'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(labelText: 'Zip Code'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your zip code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // Email Info if not logged in
              if (!widget.isLoggedIn) ...[
                Text('Email Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
              ],

              // Submit Button
              _isProcessingPayment
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () {
                  if (_paymentFormKey.currentState?.validate() ?? false) {
                    if (_addressFormKey.currentState?.validate() ?? false) {
                      // Start processing payment
                      _processPayment(context);
                    }
                  }
                },
                child: Text('Submit Payment'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              if (_paymentStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _paymentStatus,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _paymentStatus == 'Payment processed successfully' ? Colors.green : Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    setState(() {
      _isProcessingPayment = true;
      _paymentStatus = 'Processing payment...';
    });

    // Simulate a payment process with a delay of 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isProcessingPayment = false;
        _paymentStatus = 'Payment processed successfully';
      });

      // After 2 seconds, navigate back to the main screen
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      });
    });
  }
}




class Product {
  final String name;
  final String category;
  final String imagePath;
  final double price;
  final String description;
  final int review;

  Product({
    required this.name,
    required this.category,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.review,
  });
}


List<Product> getRandomProducts(List<Product> productList, int count) {
  final random = Random();
  final productsCopy = List<Product>.from(productList);
  productsCopy.shuffle(random);
  return productsCopy.take(count).toList();
}

final Map<String, List<Product>> productCategories = {
  'Featured': getRandomProducts(products, 8),
  'New Arrivals': getRandomProducts(products, 8),
  'Best Sellers': getRandomProducts(products, 8),
  'Great Deals': getRandomProducts(products, 8),
};




final List<Product> products = [
  // Graphics Cards
  Product(
    name: 'NVIDIA GeForce RTX 4090',
    category: 'Graphics Card',
    imagePath: 'assets/4090.jpg',
    price: 1599.99,
    description: 'The NVIDIA GeForce RTX 4090 delivers groundbreaking performance for gaming and AI tasks, featuring DLSS 3 and 24GB of GDDR6X memory.',
    review: 5,
  ),
  Product(
    name: 'AMD Radeon RX 7900 XTX',
    category: 'Graphics Card',
    imagePath: 'assets/7900.jpg',
    price: 999.99,
    description: 'AMD Radeon RX 7900 XTX offers incredible performance and stunning visuals with 20GB GDDR6 memory and RDNA 3 architecture.',
    review: 5,
  ),
  Product(
    name: 'NVIDIA GeForce RTX 3060 Ti',
    category: 'Graphics Card',
    imagePath: 'assets/3060.jpg',
    price: 399.99,
    description: 'A mid-range powerhouse, the RTX 3060 Ti features 8GB of GDDR6 memory, perfect for 1440p gaming and creative workloads.',
    review: 4,
  ),
  Product(
    name: 'AMD Radeon RX 6650 XT',
    category: 'Graphics Card',
    imagePath: 'assets/6650.jpg',
    price: 299.99,
    description: 'The RX 6650 XT offers excellent 1080p gaming performance and efficiency with AMD FidelityFX Super Resolution support.',
    review: 4,
  ),
  Product(
    name: 'NVIDIA GeForce GTX 1660 Super',
    category: 'Graphics Card',
    imagePath: 'assets/1660.jpg',
    price: 229.99,
    description: 'An affordable GPU for entry-level gamers, the GTX 1660 Super delivers smooth 1080p gaming with 6GB GDDR5 memory.',
    review: 3,
  ),

  // Processors
  Product(
    name: 'AMD Ryzen 9 7950X',
    category: 'Processor',
    imagePath: 'assets/ryzen9.jpg',
    price: 699.99,
    description: 'The AMD Ryzen 9 7950X is a 16-core, 32-thread beast for high-end gaming and productivity, based on Zen 4 architecture.',
    review: 5,
  ),
  Product(
    name: 'Intel Core i9-13900K',
    category: 'Processor',
    imagePath: 'assets/I9.jpg',
    price: 599.99,
    description: 'Intel Core i9-13900K offers 24 cores and 32 threads, perfect for gamers and creators seeking ultimate performance.',
    review: 5,
  ),
  Product(
    name: 'AMD Ryzen 5 5600X',
    category: 'Processor',
    imagePath: 'assets/ryzen.jpg',
    price: 229.99,
    description: 'A 6-core, 12-thread processor with excellent gaming performance, the Ryzen 5 5600X is built on the Zen 3 architecture.',
    review: 4,
  ),
  Product(
    name: 'Intel Core i7-12700K',
    category: 'Processor',
    imagePath: 'assets/I7.jpg',
    price: 399.99,
    description: 'The Intel Core i7-12700K delivers high-end gaming and productivity with 12 cores and support for DDR5 memory.',
    review: 5,
  ),
  Product(
    name: 'AMD Ryzen 7 5800X3D',
    category: 'Processor',
    imagePath: 'assets/ryzen7.jpg',
    price: 399.99,
    description: 'With 3D V-Cache technology, the Ryzen 7 5800X3D is optimized for gaming with 8 cores and 16 threads.',
    review: 4,
  ),

  // Motherboards
  Product(
    name: 'ASUS ROG Strix X670E-E Gaming WiFi',
    category: 'Motherboard',
    imagePath: 'assets/rog.png',
    price: 499.99,
    description: 'A high-performance ATX motherboard for Ryzen 7000 series CPUs, featuring PCIe 5.0 and DDR5 support.',
    review: 5,
  ),
  Product(
    name: 'MSI MPG Z790 Carbon WiFi',
    category: 'Motherboard',
    imagePath: 'assets/msimpg.jpg',
    price: 399.99,
    description: 'A premium motherboard for Intel 13th Gen processors, featuring WiFi 6E, DDR5 support, and PCIe 5.0 slots.',
    review: 4,
  ),
  Product(
    name: 'Gigabyte B550 AORUS Elite',
    category: 'Motherboard',
    imagePath: 'assets/gigabyte.png',
    price: 149.99,
    description: 'An excellent mid-range motherboard for Ryzen processors with PCIe 4.0 and robust power delivery.',
    review: 4,
  ),
  Product(
    name: 'ASRock B660M Pro RS',
    category: 'Motherboard',
    imagePath: 'assets/asrock.jpg',
    price: 129.99,
    description: 'A micro-ATX motherboard for Intel 12th Gen CPUs, perfect for budget builds with essential features.',
    review: 3,
  ),
  Product(
    name: 'MSI PRO Z690-A DDR4',
    category: 'Motherboard',
    imagePath: 'assets/msipro.jpg',
    price: 239.99,
    description: 'Designed for professionals and enthusiasts, this motherboard supports Intel 12th Gen CPUs and DDR4 memory.',
    review: 5,
  ),

  // Power Supplies
  Product(
    name: 'Corsair RM850x (2021)',
    category: 'Power Supply',
    imagePath: 'assets/corsair.jpg',
    price: 139.99,
    description: 'A reliable 850W power supply with 80+ Gold certification, featuring fully modular cables for easy cable management.',
    review: 5,
  ),
  Product(
    name: 'EVGA SuperNOVA 1000 G6',
    category: 'Power Supply',
    imagePath: 'assets/evga1000.png',
    price: 199.99,
    description: 'A high-capacity 1000W PSU with 80+ Gold efficiency, ideal for power-hungry systems.',
    review: 5,
  ),
  Product(
    name: 'Seasonic FOCUS GX-750',
    category: 'Power Supply',
    imagePath: 'assets/seasonic.jpg',
    price: 119.99,
    description: 'A compact 750W PSU with fully modular cables, 80+ Gold certification, and a 10-year warranty.',
    review: 4,
  ),
  Product(
    name: 'Cooler Master MWE 650 V2',
    category: 'Power Supply',
    imagePath: 'assets/coolermaster.jpg',
    price: 69.99,
    description: 'An affordable 650W PSU with 80+ Bronze certification, designed for budget gaming PCs.',
    review: 4,
  ),
  Product(
    name: 'Thermaltake Smart RGB 500W',
    category: 'Power Supply',
    imagePath: 'assets/thermal.jpg',
    price: 49.99,
    description: 'A basic 500W PSU with RGB lighting and quiet operation, suitable for entry-level builds.',
    review: 3,
  ),

  // Prebuilt Desktops
  Product(
    name: 'CyberPowerPC Gamer Xtreme VR',
    category: 'Prebuilt Desktop',
    imagePath: 'assets/xrteme.jpg',
    price: 1199.99,
    description: 'Specs: Intel Core i5-12400F, NVIDIA GeForce RTX 3060, 16GB DDR4 RAM, 500GB SSD, Windows 11 Home.',
    review: 5,
  ),
  Product(
    name: 'iBUYPOWER Trace MR Gaming Desktop',
    category: 'Prebuilt Desktop',
    imagePath: 'assets/ibuy.jpg',
    price: 1499.99,
    description: 'Specs: AMD Ryzen 7 5800X, NVIDIA GeForce RTX 3070, 16GB DDR4 RAM, 1TB NVMe SSD, RGB case.',
    review: 4,
  ),
  Product(
    name: 'Alienware Aurora R15',
    category: 'Prebuilt Desktop',
    imagePath: 'assets/alienware.jpg',
    price: 2999.99,
    description: 'Specs: Intel Core i9-13900KF, NVIDIA GeForce RTX 4090, 32GB DDR5 RAM, 2TB SSD + 2TB HDD.',
    review: 5,
  ),
  Product(
    name: 'HP Omen 25L Gaming Desktop',
    category: 'Prebuilt Desktop',
    imagePath: 'assets/omen.png',
    price: 999.99,
    description: 'Specs: AMD Ryzen 5 5600G, AMD Radeon RX 6600, 16GB DDR4 RAM, 512GB SSD, Windows 11 Home.',
    review: 4,
  ),
  Product(
    name: 'Lenovo Legion Tower 5i',
    category: 'Prebuilt Desktop',
    imagePath: 'assets/legion.jpg',
    price: 1299.99,
    description: 'Specs: Intel Core i7-12700, NVIDIA GeForce RTX 3060 Ti, 16GB DDR5 RAM, 1TB SSD.',
    review: 4,
  ),
];
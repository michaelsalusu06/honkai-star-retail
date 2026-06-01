import 'package:flutter/material.dart';
import 'myorder.dart'; // Grants access to GlobalOrderStorage

class ProductDetailPage extends StatelessWidget {
  // 1. Define the dynamic properties the page needs to change
  final String title;
  final String price;
  final String ratingMeta;
  final String description;
  final Color accentColor;

  const ProductDetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.ratingMeta,
    required this.description,
    this.accentColor = const Color(0xFF53565A), // Default grey canvas if none provided
  });

  // 2. Centralized, reusable cart helper method
  void _executeAddToCart(BuildContext context) {
    GlobalOrderStorage.addOrder(title, price);
    
    // Custom Neo-Brutalist styled Toast/Snackbar notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFCDD67), // Matches your brand yellow
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        content: Text(
          'Staged $title inside cosmic cart!',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: Column(
          children: [
            // TOP NAVIGATION ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, size: 32, color: Colors.black),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 26, color: Colors.black),
                      SizedBox(width: 20),
                      Icon(Icons.shopping_cart_outlined, size: 26, color: Colors.black),
                      SizedBox(width: 20),
                      Icon(Icons.search_rounded, size: 26, color: Colors.black),
                    ],
                  )
                ],
              ),
            ),

            // DYNAMIC MEDIA CANVAS BOX
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: accentColor, // Uses the custom color passed in
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),
            ),

            // TEXT DISPLAY SCROLL CONTAINER
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price, // Dynamic
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title, // Dynamic
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ratingMeta, // Dynamic
                      style: const TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(width: double.infinity, height: 2, color: Colors.black12),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description, // Dynamic
                      style: const TextStyle(fontSize: 14.5, color: Colors.black87, height: 1.6, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            // FOOTER CORE TRANSACTION UTILITY ACTION STRIP
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8ECAA7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black, size: 24),
                  ),
                  const SizedBox(width: 16),
                  
                  // Reusable Add Cart Button Trigger
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _executeAddToCart(context), // Cleans up layout lines
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9AD1F5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                        ),
                        child: const Center(
                          child: Text('Add Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _executeAddToCart(context); // Optional cascading convenience
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCDD67),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                        ),
                        child: const Center(
                          child: Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
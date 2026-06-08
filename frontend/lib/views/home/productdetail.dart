import 'package:flutter/material.dart';
import 'myorder.dart'; // Grants access to GlobalOrderStorage
import 'checkout.dart'; // Handles secure checkout routing validation payloads

class ProductDetailPage extends StatelessWidget {
  // ─── DYNAMIC METRIC ACCESS PROPERTIES ───────────────────────────────
  final String id; // 🚀 ADDED: Tracks the exact MySQL database row item key
  final String title;
  final String price;
  final String ratingMeta;
  final String description;
  final Color accentColor;

  const ProductDetailPage({
    super.key,
    required this.id, // Binds the structural resource primary row index
    required this.title,
    required this.price,
    required this.ratingMeta,
    required this.description,
    this.accentColor = const Color(0xFF53565A), // Default grey canvas if none provided
  });

  // ─── CENTRALIZED CAROUSEL CART UTILITY METHOD ───────────────────────
  void _executeAddToCart(BuildContext context) {
    GlobalOrderStorage.addOrder(title, price);
    
    // Custom Neo-Brutalist styled Toast/Snackbar notification matching your exact typography
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
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream background canvas
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP NAVIGATION ROW (RETAINED ORIGINAL DESIGN)
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

            // 2. DYNAMIC MEDIA CANVAS BOX (RETAINED ORIGINAL FLEX RATIO)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: accentColor, // Uses the custom color passed in natively
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),
            ),

            // 3. TEXT DISPLAY SCROLL CONTAINER (RETAINED ORIGINAL FONTS & METRICS)
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price, // Dynamic data binding
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title, // Dynamic data binding
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ratingMeta, // Dynamic data binding
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
                      description, // Dynamic data binding
                      style: const TextStyle(fontSize: 14.5, color: Colors.black87, height: 1.6, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            // 4. FOOTER CORE TRANSACTION UTILITY ACTION STRIP (RETAINED CHAT BUTTON AND ACCENT STYLING)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Neo-Brutalist Green Chat Bubble Icon Box Container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8ECAA7), // Mint Green
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black, size: 24),
                  ),
                  const SizedBox(width: 16),
                  
                  // Reusable Pastel Sky Blue Add Cart Button Trigger
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _executeAddToCart(context), 
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9AD1F5), // Pastel Blue Accent
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                        ),
                        child: const Center(
                          child: Text(
                            'Add Cart', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Yellow Buy Now Button Trigger Wired Safely to Backend Context
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 🚀 PASSES REAL DATABASE IDENTITY MAP DIRECTLY INTO CHECKOUT CONTEXT
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              checkoutItems: [
                                {
                                  'id': id, 
                                  'price': price, 
                                  'title': title
                                }
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCDD67), // Brand Signature Yellow Accent
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                        ),
                        child: const Center(
                          child: Text(
                            'Buy Now', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
                          ),
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
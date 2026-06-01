import 'package:flutter/material.dart';

class Menu4Page extends StatelessWidget {
  const Menu4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF53565A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '4000 Stellar Jade',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'In the Night',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '⭐ 4.7 - 120 sold - 3 product(s) left',
                      style: TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(width: double.infinity, height: 2, color: Colors.black12),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'An ultra-rare combat light cone radiating an enigmatic dark aura. Grants a phenomenal, cascading acceleration multiplier to pathwalkers dedicated strictly to The Hunt.',
                      style: TextStyle(fontSize: 14.5, color: Colors.black87, height: 1.6, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item staged inside cosmic cart!')));
                      },
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing interastral order...')));
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
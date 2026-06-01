import 'package:flutter/material.dart';
import 'homepage.dart'; // Imports your dashboard file directly

class PayNowPage extends StatelessWidget {
  const PayNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Signature warm cream background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            
            // TOP STATUS TITLE HEADER
            const Center(
              child: Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Top Clean Accent Divider Line
            Container(width: double.infinity, height: 1.5, color: Colors.black),

            // CENTERED ILLUSTRATION & TEXT SUCCESS DECK
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Neo-Brutalist Green Checkmark Badge with Solid Drop Shadow
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8ECAA7), // Pastel mint green accent color
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(5, 5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded, // Smooth sharp success check icon
                      size: 64,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Primary Status Label
                  const Text(
                    'Payment Success',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // BOTTOM NAVIGATION ACTIONS SECTION
            Container(width: double.infinity, height: 1.5, color: Colors.black),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap: () {
                  // Destroys the transaction and checkout route history stacks 
                  // to land cleanly back on the core home interface shell safely.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8ECAA7), // Matching signature brand green
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(5, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
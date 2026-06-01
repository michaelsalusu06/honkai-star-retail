import 'package:flutter/material.dart';
import 'page3.dart'; // Import page3 for navigation

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream/off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive Back Arrow Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Transitions smoothly back to Page1
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.black,
                  ),
                ),
              ),

              // Main Component Body
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // Central Mint Delivery Badge with Thick Outline and Solid Black Shadow
                    Center(
                      child: Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8ECAA7), // Precise pastel mint green
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
                          Icons.local_shipping_rounded, // Delivery/Warp speed truck icon
                          size: 54,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Title Headline Text
                    const Text(
                      'Warp-Speed Delivery',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Body Paragraph Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'No matter where you are in the cosmos, purchase your galactic resources instantly. Your supplies will be warped straight into your inventory box.',
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(flex: 4),

                    // Clickable "Next" Button with Solid Offset Shadow
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Page3()),
                        );
                      },
                      child: Container(
                        width: 135,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9AD1F5), // Unified pastel blue button color
                          borderRadius: BorderRadius.circular(16),
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
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 4),

                    // Bottom Progress Indicator Dots (Second dot highlighted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Inactive Dot 1
                        Container(
                          width: 11,
                          height: 11,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Active Circle (Blue with black outline)
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9AD1F5),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Inactive Dot 2
                        Container(
                          width: 11,
                          height: 11,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
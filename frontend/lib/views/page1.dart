import 'package:flutter/material.dart';
import 'page2.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream/off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 4),

              // Central Yellow Star Badge with Thick Outline and Solid Black Shadow
              Center(
                child: Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCDD67), // Matte yellow color accent
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.brightness_5_rounded, // Core 8-pointed star frame
                        size: 68,
                        color: Colors.black,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCDD67),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded, // Center star component
                        size: 34,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Title Headline Text
              const Text(
                'Unlock Sealed\nMemories',
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
                  'Browse through a massive intergalactic archive of rare Light Cones. Enhance your paths and prepare your team for the unpredictable dangers of the star rail.',
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
                    MaterialPageRoute(builder: (context) => const Page2()),
                  );
                },
                child: Container(
                  width: 135,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9AD1F5), // Pastel sky blue color accent
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

              // Bottom Progress Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
      ),
    );
  }
}
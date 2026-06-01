import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

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
                  Navigator.pop(context); // Transitions smoothly back to Page2
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

              const SizedBox(height: 64),

              // Title Headline Text (Chunky Neo-Brutalist alignment)
              const Text(
                'Honkai Star\nRetail',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),

              const SizedBox(height: 16),

              // Sharp Black Accent Line Divider
              Container(
                width: double.infinity,
                height: 2.5,
                color: Colors.black,
              ),

              const SizedBox(height: 24),

              // Body Paragraph Text
              const Text(
                'Equip your Trailblaze journey with the finest Light Cones and the most complete galactic resources. Ready to be delivered straight to your Astral Express cabin.',
                style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.black,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 5),

              // Side-by-Side Action Buttons Block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clickable Login Button (Yellow Accent)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCDD67), // Brand yellow from Page1
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
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 20), // Spacing between buttons
                  
                  // Clickable Sign Up Button (Mint Green Accent)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8ECAA7), // Brand green from Page2
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
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 4),

              // Bottom Progress Indicator Dots (Third dot highlighted)
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
                  // Inactive Dot 2
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
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
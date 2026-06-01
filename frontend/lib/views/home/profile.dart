import 'package:flutter/material.dart';
import 'homepage.dart';
import 'myorder.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream background
      body: SafeArea(
        child: Stack(
          children: [
            // MAIN SCROLLABLE CONTENT BODY
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120.0), // Padding to prevent nav bar overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // SCREEN HEADER TITLE
                  const Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Top Separation Divider Line
                  Container(width: double.infinity, height: 1.5, color: Colors.black),

                  // USER PROFILE ACCOUNT INFOCARD BLOCK
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        // Circular Mint Green Avatar Frame with Solid Shadow Offset
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8ECAA7), // Precise mint green avatar palette
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        
                        // User Account Identity Labels
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trailblazer Caelus',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '@caelus6767',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // User Info Accent Line Divider
                  Container(width: double.infinity, height: 1.5, color: Colors.black),

                  // SECTION 1: TRANSACTION PILLS DESK
                  _buildSectionHeader('Transaction'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCapsuleButton('On Deliver'),
                        _buildCapsuleButton('Arrived'),
                        _buildCapsuleButton('Rating'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SECTION 2: ANOTHER MENU EXTENDED NAVIGATION
                  _buildSectionHeader('Another Menu'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        _buildWideMenuButton('Wishlist'),
                        const SizedBox(width: 16),
                        _buildWideMenuButton('History'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // SECTION 3: RECOMMENDATION PRODUCT GRID LIST
                  _buildSectionHeader('Recommendation For You'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Scroll handled by core wrapper
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.78,
                      children: [
                        _buildRecommendationCard(
                          title: 'Penacony Galac ...',
                          price: '160 Stellar Jade',
                          meta: '⭐ 4.8 - 10K sold',
                        ),
                        _buildRecommendationCard(
                          title: 'Cruising in th ...',
                          price: '1200 Stellar Jade',
                          meta: '⭐ 4.3 - 72 sold',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FIXED STICKY NAVIGATION BAR (Profile Button Active)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // LEFT BUTTON: Home Redirect
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.black, size: 28),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                    ),

                    // MIDDLE BUTTON: Orders Redirect
                    IconButton(
                      icon: const Icon(Icons.archive_outlined, color: Colors.black, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyOrderPage()),
                        );
                      },
                    ),

                    // RIGHT BUTTON: Profile Active Highlighted Box (Pastel Blue)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9AD1F5), // Precise pastel blue color badge outline
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.black, size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to draw clean Courier header text blocks
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  // Builder for compact pills underneath Transaction section
  Widget _buildCapsuleButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  // Builder for wide side-by-side buttons under Another Menu section
  Widget _buildWideMenuButton(String label) {
    return Expanded(
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
          ),
        ],
      ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontFamily: 'Courier',
            ),
          ),
        ),
      ),
    );
  }

  // Builder for product collection grid list matching dashboard style
  Widget _buildRecommendationCard({
    required String title,
    required String price,
    required String meta,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9), // Gray item card block asset box
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Courier'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              meta,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54, fontFamily: 'Courier'),
            ),
          ],
        ),
      ),
    );
  }
}
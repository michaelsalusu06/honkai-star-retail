import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'myorder.dart';              // Relative path to your myorder file
import 'profile.dart';              // Relative path to your profile file
import 'productdetail.dart';        // Single reusable detail page replacing menu1-4

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _resources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveResources();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── HTTP GET: RETRIEVE LIVE RESOURCES FROM MYSQL ─────────────────
  Future<void> _fetchLiveResources() async {
    final url = Uri.parse('http://localhost:5000/api/resources');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _resources = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch resources: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream background
      body: SafeArea(
        child: Stack(
          children: [
            // SCROLLABLE BODY CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 110.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Header Row
                  const Text(
                    'Hi, Trailblazer Caelus',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TYPEABLE SEARCH ROW + FILTER BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Search here...',
                              hintStyle: TextStyle(color: Colors.black38, fontFamily: 'Courier'),
                              prefixIcon: Icon(Icons.search_rounded, color: Colors.black, size: 24),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Neo-Brutalist Filter Icon Button (Mint Green)
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8ECAA7), // Pastel mint green
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list_rounded, color: Colors.black, size: 26),
                          onPressed: () {
                            // Quick placeholder callback action
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // INTERACTIVE ACCENT CAROUSEL BANNER (Yellow)
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCDD67), // Banner yellow accent
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('←', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
                          Text('→', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carousel Indicators Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9AD1F5), // Active indicator blue
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ─── DYNAMIC INVENTORY GRID SYSTEM (WIRED TO MYSQL) ───
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.black))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Disables inner grid scrolling
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.78, // Preserves exact mockup aspect constraints
                          ),
                          itemCount: _resources.length,
                          itemBuilder: (context, index) {
                            final item = _resources[index];
                            return _buildProductCard(
                              context,
                              title: item['name'] ?? 'Galactic Resource',
                              price: '${item['price'] ?? 0} Stellar Jade',
                              meta: 'Stock: ${item['stock'] ?? 0} | ${item['type'] ?? 'Item'}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      id: item['id'].toString(), // Securely binds dynamic ID map sequence
                                      title: item['name'] ?? 'Galactic Resource',
                                      price: '${item['price'] ?? 0} Stellar Jade',
                                      ratingMeta: 'Stock: ${item['stock'] ?? 0} | Type: ${item['type'] ?? 'Resource'}',
                                      description: item['description'] ?? 'A premium galactic resource stored directly within the database registry.',
                                      accentColor: const Color(0xFF9AD1F5), // Standard matching header accent color block
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            ),

            // FIXED STICKY NAVIGATION CORE BAR
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
                    // LEFT BUTTON: Home Active (Highlighted Box styling matching your mockup)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCDD67), // Highlighted yellow background box
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.black, size: 24),
                    ),

                    // MIDDLE BUTTON: Orders view route redirect
                    IconButton(
                      icon: const Icon(Icons.archive_outlined, color: Colors.black, size: 28),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrderPage()));
                      },
                    ),

                    // RIGHT BUTTON: Profile view route redirect
                    IconButton(
                      icon: const Icon(Icons.person_outline_rounded, color: Colors.black, size: 28),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                      },
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

  // Extracted Component Reusable Template to build matched grid display tiles
  Widget _buildProductCard(
    BuildContext context, {
    required String title,
    required String price,
    required String meta,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              // Inside top generic grey item image placeholder frame
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9), // Flat grey placeholder
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Item Text Title Label
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Courier'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Pricing text indicator label
              Text(
                price,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(height: 4),
              // Ratings and counts data meta row
              Text(
                meta,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54, fontFamily: 'Courier'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'profile.dart';
import 'checkout.dart'; // Import your newly created checkout view file

// =========================================================================
// GLOBAL STATE MANAGER
// =========================================================================
class GlobalOrderStorage {
  // Master list of orders across the application
  static final List<Map<String, String>> activeOrders = [
    {
      'title': 'Penacony Galactic Resource',
      'price': '160 Stellar Jade',
    },
    {
      'title': 'Cruising in the Stellar Sea',
      'price': '1200 Stellar Jade',
    }
  ];

  static void addOrder(String title, String price) {
    activeOrders.add({
      'title': title,
      'price': price,
    });
  }
}

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  // List tracking which indexes are currently selected by the user
  List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectionList();
  }

  // Ensures our selection tracking array matches the size of our global list
  void _initializeSelectionList() {
    _selectedItems = List<bool>.filled(GlobalOrderStorage.activeOrders.length, false);
  }

  // Helper method to show customized Neo-Brutalist alert notifications
  void _showBrutalistSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 110),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
        ),
      ),
    );
  }

  // Action method to cancel all checked items
  void _cancelSelectedOrders() {
    List<Map<String, String>> itemsToRemove = [];
    
    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        itemsToRemove.add(GlobalOrderStorage.activeOrders[i]);
      }
    }

    setState(() {
      for (var item in itemsToRemove) {
        GlobalOrderStorage.activeOrders.remove(item);
      }
      _initializeSelectionList(); // Re-index matching updated list
    });

    _showBrutalistSnackBar('Selected warp dispatches canceled successfully!', const Color(0xFFE57373));
  }

  // Action method to checkout all checked items and send them to checkout.dart
  void _checkoutSelectedOrders() {
    List<Map<String, String>> itemsToCheckout = [];
    
    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        itemsToCheckout.add(GlobalOrderStorage.activeOrders[i]);
      }
    }

    if (itemsToCheckout.isEmpty) {
      _showBrutalistSnackBar('Please select at least one item to checkout!', const Color(0xFFFCDD67));
      return;
    }

    // Direct user to the checkout screen while passing the list of selected items!
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(checkoutItems: itemsToCheckout),
      ),
    ).then((_) {
      // Optional: Refresh checkboxes selection flags when returning back to this page
      setState(() {
        _initializeSelectionList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if at least one checkbox is marked true
    bool hasSelection = _selectedItems.contains(true);

    // If items were added from details pages, expand selection array to handle them safely
    if (_selectedItems.length != GlobalOrderStorage.activeOrders.length) {
      _initializeSelectionList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: Stack(
          children: [
            // MAIN VIEWPORTS
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'My Orders',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
                ),
                const SizedBox(height: 16),
                Container(width: double.infinity, height: 1.5, color: Colors.black),

                // FILTER SECTIONS STRIP
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildFilterTab('On Deliver', isActive: true, color: const Color(0xFFFCDD67)),
                        const SizedBox(width: 12),
                        _buildFilterTab('Arrived', isActive: false),
                        const SizedBox(width: 12),
                        _buildFilterTab('Cancelled', isActive: false),
                      ],
                    ),
                  ),
                ),
                Container(width: double.infinity, height: 1.5, color: Colors.black12),

                // SCROLLABLE INTERACTIVE LIST BUILDER
                Expanded(
                  child: GlobalOrderStorage.activeOrders.isEmpty
                      ? const Center(
                          child: Text(
                            'No active warp dispatches.',
                            style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          // Extra padding at the bottom to stay clear of the action drawer and nav bar
                          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: hasSelection ? 190.0 : 120.0),
                          itemCount: GlobalOrderStorage.activeOrders.length,
                          itemBuilder: (context, index) {
                            final order = GlobalOrderStorage.activeOrders[index];
                            return _buildSelectableOrderCard(
                              index: index,
                              title: order['title'] ?? 'Galactic Item',
                              price: order['price'] ?? '0 Stellar Jade',
                            );
                          },
                        ),
                ),
              ],
            ),

            // CONDITIONAL FLOATING ACTION BAR PANEL (Appears dynamically if items are checked)
            if (hasSelection)
              Positioned(
                left: 24,
                right: 24,
                bottom: 112, // Sits clean directly overhead of the navigation block
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: Row(
                    children: [
                      // Batch Cancel Action Button (Yellow Accent Frame)
                      Expanded(
                        child: GestureDetector(
                          onTap: _cancelSelectedOrders,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCDD67),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel Item',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Batch Checkout Action Button (Mint Green Accent Frame)
                      Expanded(
                        child: GestureDetector(
                          onTap: _checkoutSelectedOrders,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8ECAA7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'Checkout',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // FIXED STICKY NAVIGATION FRAME BAR
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
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8ECAA7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(Icons.archive_rounded, color: Colors.black, size: 24),
                    ),
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

  Widget _buildFilterTab(String label, {required bool isActive, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Courier'),
      ),
    );
  }

  // Interactive Selectable Card incorporating custom square checkbox components
  Widget _buildSelectableOrderCard({required int index, required String title, required String price}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CUSTOM NEO-BRUTALIST SQUARE CHECKBOX INTERACTION FRAME
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItems[index] = !_selectedItems[index];
                    });
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(top: 26, right: 12),
                    decoration: BoxDecoration(
                      color: _selectedItems[index] ? const Color(0xFF9AD1F5) : Colors.white, // Pop blue selection fill
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 2.5),
                    ),
                    child: _selectedItems[index]
                        ? const Icon(Icons.check_rounded, color: Colors.black, size: 18, fontWeight: FontWeight.w900)
                        : null,
                  ),
                ),
                
                // Content Thumbnail Block Graphic
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Item Specifications Labels Block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: double.infinity, height: 1.5, color: Colors.black12),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: Text(
                'See Details',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Courier'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'paynow.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, String>> checkoutItems;

  const CheckoutPage({super.key, required this.checkoutItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // State option tracker for chosen payment gateway
  String _selectedPaymentMethod = 'BCA Virtual Account';

  // Helper calculation logic to extract digits from string labels (e.g. "160 Stellar Jade" -> 160)
  int _calculateSubtotal() {
    int total = 0;
    for (var item in widget.checkoutItems) {
      final priceStr = item['price'] ?? '0';
      final digitsOnly = RegExp(r'\d+').stringMatch(priceStr) ?? '0';
      total += int.parse(digitsOnly);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Math breakdowns matching the structural metrics of image_50c1e1.png
    final int subtotal = _calculateSubtotal();
    const int deliveryFee = 30;
    const int serviceFee = 16;
    const int applicationFee = 16;
    const int protectionFee = 10;
    final int totalPayment = subtotal + deliveryFee + serviceFee + applicationFee + protectionFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Signature warm cream backdrop
      body: SafeArea(
        child: Column(
          children: [
            // TOP CUSTOM APP BAR HEADER 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // Seamless step back into myorder stack
                    child: const Icon(Icons.arrow_back_rounded, size: 32, color: Colors.black),
                  ),
                  const Icon(Icons.search_rounded, size: 32, color: Colors.black),
                ],
              ),
            ),
            Container(width: double.infinity, height: 1.5, color: Colors.black),

            // MAIN SCROLLABLE CONTENT BODY
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION 1: SEND DESTINATION
                    _buildSectionHeader('Send Destination'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.map_outlined, color: Colors.black, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'My Base - Trailblazer Caelus',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black, fontFamily: 'Courier'),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Edge of the Penacony Dreamscape, Boundary Sea',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7), fontFamily: 'Courier'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: double.infinity, height: 1.5, color: Colors.black),

                    // SECTION 2: CART ITEM LIST
                    _buildSectionHeader('Cart List'),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.checkoutItems.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        final item = widget.checkoutItems[index];
                        return Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9), // Core image square gray box
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? 'Galactic Cargo Item',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['price'] ?? '0 Stellar Jade',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Container(width: double.infinity, height: 1.5, color: Colors.black),

                    // SECTION 3: PAYMENT METHOD (Labeled "Cart List" in image mockup matching exact styling reference)
                    _buildSectionHeader('Cart List'), 
                    Column(
                      children: [
                        _buildPaymentRadioTile('BCA Virtual Account'),
                        _buildPaymentRadioTile('BRI Virtual Account'),
                        _buildPaymentRadioTile('Dana'),
                        _buildPaymentRadioTile('Gopay Wallet'),
                      ],
                    ),
                    Container(width: double.infinity, height: 1.5, color: Colors.black),

                    // SECTION 4: TRANSACTION SUMMARY
                    _buildSectionHeader('Transaction Summary'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSummaryRow('Total Item Price', '$subtotal Stellar Jade'),
                          const SizedBox(height: 10),
                          _buildSummaryRow('Delivery Fee', '$deliveryFee Stellar Jade'),
                          const SizedBox(height: 10),
                          _buildSummaryRow('Service Fee', '$serviceFee Stellar Jade'),
                          const SizedBox(height: 10),
                          _buildSummaryRow('Application Fee', '$applicationFee Stellar Jade'),
                          const SizedBox(height: 10),
                          _buildSummaryRow('Protection Fee', '$protectionFee Stellar Jade'),
                        ],
                      ),
                    ),
                    Container(width: double.infinity, height: 1.5, color: Colors.black),

                    // SECTION 5: FINAL TOTAL ROW
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Total',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, fontFamily: 'Courier'),
                          ),
                          Text(
                            '$totalPayment Stellar Jade',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    // INTERACTIVE PAY NOW ACTION SUBMIT BUTTON (Mint Green)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PayNowPage()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8ECAA7), // Pastel mint green block color
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(5, 5),
                                blurRadius: 0,
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Pay Now',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ),
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

  // Component framework to draw section title headers matching the image layout cuts
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: Colors.transparent,
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black, fontFamily: 'Courier'),
      ),
    );
  }

  // Component tile template configuration to handle interactive payment selection clicks
  Widget _buildPaymentRadioTile(String methodName) {
    final bool isSelected = _selectedPaymentMethod == methodName;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = methodName;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9), shape: BoxShape.rectangle),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                methodName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
              ),
            ),
            // Custom Neo-Brutalist green core radio indicator node
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8ECAA7), // Matching green radio dot fill inside selection
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Row element formatter for transaction calculations
  Widget _buildSummaryRow(String attribute, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(attribute, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier')),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier')),
      ],
    );
  }
}
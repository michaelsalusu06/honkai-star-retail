import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html; // 🚀 Pulls secure admin Bearer credentials from local storage partitions
import 'package:http/http.dart' as http;
import 'addresource.dart';
import 'update.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _inventoryItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchLiveInventory(); // 🚀 Automatically pulls real MySQL data when the page loads
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── RETRIEVE: FETCH DATABASE ROWS FROM NODE.JS API ───────────────────
  Future<void> _fetchLiveInventory() async {
    final url = Uri.parse('http://localhost:5000/api/resources');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _inventoryItems = jsonDecode(response.body);
          _isLoading = false;
          _errorMessage = '';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'SERVER RETURNED ERROR STATUS: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'CONNECTION ERROR: CANNOT CONNECT TO BACKEND ENGINE';
      });
    }
  }

  // ─── DELETE: INLINE HTTP DELETE SERVICE HANDSHAKE LOOP ────────────────
  Future<void> _deleteResourceFromDatabase(int itemId) async {
    setState(() => _isLoading = true);
    final token = html.window.localStorage['token'] ?? '';
    final url = Uri.parse('http://localhost:5000/api/resources/$itemId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Protected via secure admin verification shield
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resource successfully dropped from database registry!', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // 🚀 Auto-refresh data mapping layers instantaneously from source definitions
        _fetchLiveInventory();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deletion failed. Admin permission clearance required.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error executing row deletion.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
      );
    }
  }

  // ─── CUSTOM NEO-BRUTALIST DELETE CONFIRMATION POPUP ───────────────────
  void _showDeleteDialog(BuildContext context, String itemTitle, int itemId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDE4D),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2.5),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'DELETE\nRESOURCE?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black, height: 1.4, fontWeight: FontWeight.w500),
                    children: [
                      const TextSpan(text: 'Are you sure you want to delete\n'),
                      TextSpan(text: '"$itemTitle"', style: const TextStyle(fontWeight: FontWeight.w900)),
                      const TextSpan(text: '? This action cannot be undone.'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                
                // YES, DELETE ACTION BUTTON CONTAINER
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // 🚀 Triggers network deduction block directly passing live MySQL database ID row index
                      _deleteResourceFromDatabase(itemId);
                    },
                    child: const Center(
                      child: Text('YES, DELETE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Text('CANCEL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER BAR
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ADMIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0)),
                      Text('DASHBOARD', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // STATS GRID SUMMARY
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDE4D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TOTAL ITEMS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black)),
                          const SizedBox(height: 16),
                          Text('${_inventoryItems.length}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9AD1F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOW STOCK ALERT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black)),
                          SizedBox(height: 32),
                          Text('3', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFFFF3B30), height: 1.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ADD NEW RESOURCE BUTTON
              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF9DE9CE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const AddResourcePage())
                    ).then((_) => _fetchLiveInventory()); // 🚀 Cascades automatic interface refresh updates upon closure
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.black, size: 28),
                      SizedBox(width: 8),
                      Text('ADD NEW RESOURCE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // SEARCH BAR
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.black54, size: 24),
                          hintText: 'Search resource...',
                          hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 28),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              const Text('INVENTORY', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black)),
              const SizedBox(height: 16),

              // DYNAMIC INVENTORY LIST RENDER BLOCK
              if (_isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator(color: Colors.black)))
              else if (_inventoryItems.isEmpty)
                const Center(child: Text('NO ITEMS IN MYSQL DATABASE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _inventoryItems.length,
                  itemBuilder: (context, index) {
                    final item = _inventoryItems[index];
                    return _buildInventoryItem(
                      itemRawMap: item, // 🚀 Passes the underlying direct resource structure payload map downstream safely
                      id: item['id'] ?? 0,
                      title: item['name'] ?? 'Unknown Asset',
                      type: item['type'] ?? 'Material',
                      stats: '${item['price']} SJ  -  ',
                      stockText: '${item['stock']} Left',
                      isLowStock: (item['stock'] ?? 0) <= 5,
                      hasImage: item['image'] != null,
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryItem({
    required Map<String, dynamic> itemRawMap, // 🚀 Catches full raw database column cell configuration maps
    required int id,
    required String title,
    required String type,
    required String stats,
    required String stockText,
    required bool isLowStock,
    required bool hasImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: hasImage
                ? const Icon(Icons.image_rounded, color: Colors.black45, size: 28)
                : const Icon(Icons.image_outlined, color: Colors.black38, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                const SizedBox(height: 2),
                Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black38)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black),
                    children: [
                      TextSpan(text: stats),
                      TextSpan(text: stockText, style: TextStyle(color: isLowStock ? const Color(0xFFFF3B30) : Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF9AD1F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit_outlined, color: Colors.black, size: 18),
                  onPressed: () {
                    // 🚀 FIXED: Passes the explicit map parameters forward to bypass default fallbacks
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePage(resourceData: itemRawMap),
                      ),
                    ).then((_) => _fetchLiveInventory()); // Re-queries table records immediately upon popping view panel
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFA5A5A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 18),
                  onPressed: () {
                    _showDeleteDialog(context, title, id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
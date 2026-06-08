import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html; // 🚀 Crucial for local computer file pickups and token reads
import 'package:http/http.dart' as http;

class AddResourcePage extends StatefulWidget {
  const AddResourcePage({super.key});

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedType;
  final List<String> _resourceTypes = ['Currency', 'Consumable', 'Material', 'Light Cone', 'Pass', 'Bundle', 'Subscription'];
  bool _isLoading = false;

  // 🚀 Local tracking state variables for the uploaded computer asset file byte data
  String? _base64ImageData; 
  String? _uploadedFileName;

  @override
  void initState() {
    super.initState();
    // Refresh view layer constraints instantly whenever a URL string gets typed in
    _imageUrlController.addListener(() {
      if (_imageUrlController.text.isNotEmpty) {
        setState(() {
          _base64ImageData = null; // Prioritizes the link data input channel
          _uploadedFileName = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 🚀 NEW FUNCTION: Opens the local computer file selector dialog window
  void _pickLocalComputerFile() {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();

      reader.readAsDataUrl(file); // Converts the image into a Base64 Data URL string safely
      reader.onLoadEnd.listen((loadEndEvent) {
        setState(() {
          _base64ImageData = reader.result as String?;
          _uploadedFileName = file.name;
          _imageUrlController.clear(); // Clears text input link channel to avoid collisions
        });
      });
    });
  }

  Future<void> _submitResource() async {
    final String name = _nameController.text.trim();
    final String price = _priceController.text.trim();
    final String stock = _stockController.text.trim();

    if (name.isEmpty || price.isEmpty || stock.isEmpty || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name, Type, Price, and Stock parameters are required!'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isLoading = true);
    final url = Uri.parse('http://localhost:5000/api/resources');
    final token = html.window.localStorage['token'] ?? '';

    // Prioritizes file base64 data layout schema representation format, defaults back to the raw pasted URL string data entry
    final String? finalImagePayload = _base64ImageData ?? (_imageUrlController.text.isEmpty ? null : _imageUrlController.text.trim());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'type': _selectedType,
          'description': _descriptionController.text.trim(),
          'stock': int.tryParse(stock) ?? 0,
          'price': double.tryParse(price) ?? 0.0,
          'image': finalImagePayload,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resource created successfully!'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
        );
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Creation failed.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API Network Error connection timed out.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              // HEADER BAR AREA
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
                      Text('INSERT NEW', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0)),
                      Text('RESOURCE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              _buildInputLabel('RESOURCE NAME'),
              _buildFieldContainer(
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(hintText: 'e.g., Star Rail Pass', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 24),

              _buildInputLabel('RESOURCE TYPE'),
              _buildFieldContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      hint: const Text('Select type...', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 16)),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 30),
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                      items: _resourceTypes.map((String type) => DropdownMenuItem<String>(value: type, child: Text(type))).toList(),
                      onChanged: _isLoading ? null : (String? val) => setState(() => _selectedType = val),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('PRICE'),
                        _buildFieldContainer(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  decoration: const InputDecoration(hintText: '0', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Text('SJ', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('STOCK'),
                        _buildFieldContainer(
                          child: TextField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            decoration: const InputDecoration(hintText: '0', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // DUAL ASSET IMAGE INPUT FIELD CONTROLS
              _buildInputLabel('IMAGE SETTING (UPLOAD FILE OR LINK)'),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickLocalComputerFile,
                    icon: const Icon(Icons.upload_file_rounded, color: Colors.black),
                    label: const Text('UPLOAD FROM COMPUTER', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9AD1F5),
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black, width: 2.5)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_uploadedFileName != null)
                    Expanded(child: Text('Selected: $_uploadedFileName', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier', overflow: TextOverflow.ellipsis))),
                ],
              ),
              const SizedBox(height: 12),
              _buildFieldContainer(
                child: TextField(
                  controller: _imageUrlController,
                  enabled: !_isLoading,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(hintText: 'Or paste raw web asset image url link here...', hintStyle: TextStyle(color: Colors.black26), border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 24),

              _buildInputLabel('IMAGE PREVIEW'),
              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: _base64ImageData != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_base64ImageData!, fit: BoxFit.contain))
                    : (_imageUrlController.text.trim().isEmpty
                        ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_outlined, color: Colors.black45, size: 48), SizedBox(height: 8), Text('NO IMAGE SELECTED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black45))])
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _imageUrlController.text.trim(),
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.broken_image_rounded, color: Color(0xFFFF3B30), size: 48), SizedBox(height: 8), Text('INVALID IMAGE URL ASSET', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFFF3B30)))]),
                            ),
                          )),
              ),
              const SizedBox(height: 24),

              _buildInputLabel('DESCRIPTION'),
              _buildFieldContainer(
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(hintText: 'Enter description detail sheets...', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey : const Color(0xFFFFCE50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                ),
                child: InkWell(
                  onTap: _isLoading ? null : _submitResource,
                  child: Center(
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.black) : const Text('SAVE / SUBMIT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String labelText) {
    return Padding(padding: const EdgeInsets.only(bottom: 10.0), child: Text(labelText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black)));
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]), child: child);
  }
}
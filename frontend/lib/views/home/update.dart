import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic>? resourceData;
  const UpdatePage({super.key, this.resourceData});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  String? _selectedType;
  final List<String> _resourceTypes = ['Currency', 'Consumable', 'Material', 'Light Cone', 'Pass', 'Bundle', 'Subscription'];
  bool _isLoading = false;

  String? _base64ImageData;
  String? _uploadedFileName;

  @override
  void initState() {
    super.initState();
    final data = widget.resourceData ?? {};

    _idController = TextEditingController(text: data['id']?.toString() ?? '1');
    _nameController = TextEditingController(text: data['name'] ?? 'Item Name');
    _priceController = TextEditingController(text: data['price']?.toString() ?? '0');
    _stockController = TextEditingController(text: data['stock']?.toString() ?? '0');
    _descriptionController = TextEditingController(text: data['description'] ?? '');
    _selectedType = data['type'] ?? 'Material';

    final String fallbackImg = data['image'] ?? '';
    if (fallbackImg.startsWith('data:image')) {
      _base64ImageData = fallbackImg;
      _imageUrlController = TextEditingController();
    } else {
      _imageUrlController = TextEditingController(text: fallbackImg);
    }

    _imageUrlController.addListener(() {
      if (_imageUrlController.text.isNotEmpty && mounted) {
        setState(() {
          _base64ImageData = null;
          _uploadedFileName = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickLocalComputerFile() {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((loadEndEvent) {
        setState(() {
          _base64ImageData = reader.result as String?;
          _uploadedFileName = file.name;
          _imageUrlController.clear();
        });
      });
    });
  }

  Future<void> _submitUpdate() async {
    setState(() => _isLoading = true);
    final token = html.window.localStorage['token'] ?? '';
    final updateId = _idController.text;

    final String? finalImagePayload = _base64ImageData ?? (_imageUrlController.text.isEmpty ? null : _imageUrlController.text.trim());

    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/api/resources/$updateId'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'type': _selectedType,
          'description': _descriptionController.text.trim(),
          'stock': int.tryParse(_stockController.text.trim()) ?? 0,
          'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
          'image': finalImagePayload,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated successfully!'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating));
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update failed.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network Error.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _executeDelete() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Permanently delete this row item from MySQL?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('DELETE', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    setState(() => _isLoading = true);
    final token = html.window.localStorage['token'] ?? '';
    final updateId = _idController.text;

    try {
      final response = await http.delete(Uri.parse('http://localhost:5000/api/resources/$updateId'), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted safely.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating));
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error executing deletion.'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating));
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UPDATE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0)),
                      Text('RESOURCE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              _buildInputLabel('ID RESOURCE'),
              _buildFieldContainer(backgroundColor: const Color(0xFFE5E5E5), child: TextField(controller: _idController, enabled: false, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)))),
              const SizedBox(height: 24),

              _buildInputLabel('RESOURCE NAME'),
              _buildFieldContainer(child: TextField(controller: _nameController, enabled: !_isLoading, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)))),
              const SizedBox(height: 24),

              _buildInputLabel('RESOURCE TYPE'),
              _buildFieldContainer(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedType, icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 30), isExpanded: true, dropdownColor: Colors.white, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16), items: _resourceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: _isLoading ? null : (v) => setState(() => _selectedType = v))))),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('PRICE'),
                        _buildFieldContainer(child: Row(children: [Expanded(child: TextField(controller: _priceController, enabled: !_isLoading, keyboardType: TextInputType.number, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)))), const Padding(padding: EdgeInsets.only(right: 16.0), child: Text('SJ', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16)))]))
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('STOCK'),
                        _buildFieldContainer(child: TextField(controller: _stockController, enabled: !_isLoading, keyboardType: TextInputType.number, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16))))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildInputLabel('IMAGE SETTING (UPLOAD FILE OR LINK)'),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickLocalComputerFile,
                    icon: const Icon(Icons.upload_file_rounded, color: Colors.black),
                    label: const Text('UPLOAD NEW FILE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9AD1F5), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black, width: 2.5))),
                  ),
                  const SizedBox(width: 12),
                  if (_uploadedFileName != null) Expanded(child: Text('Selected: $_uploadedFileName', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier', overflow: TextOverflow.ellipsis))),
                ],
              ),
              const SizedBox(height: 12),
              _buildFieldContainer(child: TextField(controller: _imageUrlController, enabled: !_isLoading, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), decoration: const InputDecoration(hintText: 'Or paste image link url...', border: InputBorder.none, contentPadding: EdgeInsets.all(16)))),
              const SizedBox(height: 24),

              _buildInputLabel('IMAGE PREVIEW'),
              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(color: const Color(0xFFE5E5E5), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
                child: _base64ImageData != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_base64ImageData!, fit: BoxFit.contain))
                    : (_imageUrlController.text.trim().isEmpty
                        ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_outlined, color: Colors.black45, size: 48), SizedBox(height: 8), Text('NO IMAGE SELECTED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black45))])
                        : ClipRRect(child: Image.network(_imageUrlController.text.trim(), fit: BoxFit.contain, errorBuilder: (c, e, s) => const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.broken_image_rounded, color: Color(0xFFFF3B30), size: 48), SizedBox(height: 8), Text('INVALID IMAGE URL ASSET', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFFF3B30)))])))),
              ),
              const SizedBox(height: 24),

              _buildInputLabel('DESCRIPTION'),
              _buildFieldContainer(child: TextField(controller: _descriptionController, enabled: !_isLoading, maxLines: 4, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)))),
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(color: _isLoading ? Colors.grey : const Color(0xFFFFCE50), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))]),
                child: InkWell(onTap: _isLoading ? null : _submitUpdate, child: Center(child: _isLoading ? const CircularProgressIndicator(color: Colors.black) : const Text('SAVE / SUBMIT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5)))),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(color: _isLoading ? Colors.grey : const Color(0xFFFF5A5A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))]),
                child: InkWell(onTap: _isLoading ? null : _executeDelete, child: Center(child: _isLoading ? const CircularProgressIndicator(color: Colors.black) : const Text('DELETE RESOURCE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5)))),
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

  Widget _buildFieldContainer({required Widget child, Color backgroundColor = Colors.white}) {
    return Container(decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]), child: child);
  }
}
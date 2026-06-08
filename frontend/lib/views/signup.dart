import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html; // 🚀 Required to open the OAuth URL path inside your Chrome browser window
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Text tracking controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Loading indicator and visibility toggles
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── POST: REGISTER THE USER INSIDE MYSQL ───────────────────────────
  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 1. Local validation validation boundary checks
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Please fill out all cosmic data fields!');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Verification Failed: Passwords do not match!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:5000/api/auth/register');

    try {
      // 2. Fire the network payload payload straight to the Node.js API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email, // Maps email straight to your backend's expected username key
          'password': password,
          'role': 'user',    // Sets default permissions tier natively
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Registration successful! Please log in.');
        
        // 3. Clear the validation stack and bounce them cleanly back to your login screen
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Registration failed!');
      }
    } catch (e) {
      _showSnackBar('Connection failed. Is your XAMPP and backend engine on?');
      print('Network Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Honkai Star Retail',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),

              // Main Yellow Neo-Brutalist Card Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCDD67),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // EMAIL FIELD
                    const Text(
                      'Email:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'email@pribadi.com',
                        hintStyle: TextStyle(color: Colors.black38),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 3)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // PASSWORD FIELD
                    const Text(
                      'Password:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      enabled: !_isLoading,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 3)),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CONFIRM PASSWORD FIELD
                    const Text(
                      'Confirm Password:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscured,
                      enabled: !_isLoading,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 3)),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _isConfirmPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // ─── ACTION BUTTONS ROW (SIGN UP + GOOGLE PLATFORM OAUTH) ───
                    Row(
                      children: [
                        // 1. Sign Up Submit Button
                        Expanded(
                          child: GestureDetector(
                            onTap: _isLoading ? null : _handleSignUp,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: _isLoading ? Colors.grey : const Color(0xFF8ECAA7), // Mint green
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.black, width: 2.5),
                                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.black)
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 2. Square External OAuth Platform Button
                        GestureDetector(
                          onTap: () {
                            _showSnackBar('Connecting to External Secure Sign-In...');
                            // 🚀 Directs your Chrome window right into your active backend OAuth handshake execution path
                            html.window.location.href = 'http://localhost:5000/api/oauth/github';
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black, width: 2.5),
                              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                            ),
                            child: const Center(
                              child: Text(
                                'G', // High-contrast Neo-Brutalist letter mark matching platform logo style
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // TOGGLE BACK TO LOGIN ROOT DIRECTORY
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Already Have An Account?',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: 'Courier'),
                        ),
                      ),
                    ),
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
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html; // 🚀 Required to open the OAuth URL path inside your Chrome browser window
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'home/homepage.dart';
import 'home/admin_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String inputUser = _emailController.text.trim();
    final String inputPassword = _passwordController.text.trim();

    if (inputUser.isEmpty || inputPassword.isEmpty) {
      _showSnackBar('Please fill in all fields!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:5000/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': inputUser,
          'password': inputPassword,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String userRole = responseData['user']['role'];
        String username = responseData['user']['username'];
        html.window.localStorage['token'] = responseData['token'] ?? responseData['access_token'];

        _showSnackBar('Welcome back, $username!');

        if (userRole == 'admin') {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
            (route) => false,
          );
        } else {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Invalid Credentials!');
      }
    } catch (e) {
      _showSnackBar('Connection failed. Is your backend server running?');
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
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.arrow_back_rounded, size: 32, color: Colors.black),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Welcome\nBack',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),
              Container(width: double.infinity, height: 2.5, color: Colors.black),
              const SizedBox(height: 40),
              const Text(
                'Email Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Enter your cosmic mail...',
                    hintStyle: TextStyle(color: Colors.black38),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your password...',
                    hintStyle: const TextStyle(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() => _isObscured = !_isObscured),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ─── ACTION BUTTONS ROW (LOG IN + GOOGLE PLATFORM OAUTH) ───
              Row(
                children: [
                  // 1. Log In Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading ? null : _handleLogin,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: _isLoading ? Colors.grey : const Color(0xFF9AD1F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.black)
                              : const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                  ),
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
                      // 🚀 Directs your Chrome tab right into your active backend OAuth handshake line
                      html.window.location.href = 'http://localhost:5000/api/oauth/github';
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
                      ),
                      child: const Center(
                        child: Text(
                          'G', // Clean, high-contrast Neo-Brutalist capital platform letter mark
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
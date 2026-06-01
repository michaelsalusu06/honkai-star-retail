import 'package:flutter/material.dart';
import 'login.dart';
import 'home/homepage.dart';

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

  // Independent eye-toggle states for both password fields
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Verification process to confirm details are correct
  void _handleSignUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Check for empty fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all cosmic data fields!'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    // Password comparison check
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification Failed: Passwords do not match!'),
          backgroundColor: Color(0xFFE57373), // Red accent warning alert
        ),
      );
      return;
    }

    // Success: Route to homepage and clear the onboarding memory stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream/off-white background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // App Brand Header text on top of the card
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

              // Main Neo-Brutalist Registration Card matching image_527474.png
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCDD67), // Warm yellow brand background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inner Section Header Label
                    const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // EMAIL FIELD STYLE
                    const Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Courier', // Gives a sharp data-input feel
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'email@pribadi.com',
                        hintStyle: TextStyle(color: Colors.black38),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // PASSWORD FIELD STYLE
                    const Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Courier',
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // CONFIRM PASSWORD FIELD STYLE
                    const Text(
                      'Confirm Password:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Courier',
                      ),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscured,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _isConfirmPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // CENTERED SIGN UP SUBMIT BUTTON (Mint Green Accent)
                    Center(
                      child: GestureDetector(
                        onTap: _handleSignUp,
                        child: Container(
                          width: 140,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8ECAA7), // Pastel mint green block
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
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

                    const SizedBox(height: 32),

                    // TOGGLE BACK TO LOGIN ROOT
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Clean redirect option back to Login sequence
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Already Have An Account?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Courier',
                          ),
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
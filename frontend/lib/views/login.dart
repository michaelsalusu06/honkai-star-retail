import 'package:flutter/material.dart';
import 'signup.dart';
import 'home/homepage.dart'; // Points to your empty homepage file inside the home/ folder

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Input Controllers to read typed data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable to toggle password obscure feature
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3), // Warm cream/off-white background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Title Headline
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

              // Crisp Neo-Brutalist Divider Line
              Container(
                width: double.infinity,
                height: 2.5,
                color: Colors.black,
              ),

              const SizedBox(height: 40),

              // EMAIL INPUT FIELD
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
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
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Enter your cosmic mail...',
                    hintStyle: TextStyle(color: Colors.black38),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: InputBorder.none, // Removes default underline
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // PASSWORD INPUT FIELD
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
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
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your password...',
                    hintStyle: const TextStyle(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: InputBorder.none,
                    // Interactive eye button tracking state changes
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // LOGIN ACTION BUTTON
              GestureDetector(
                onTap: () {
                  // Destroys onboarding views tree and sets dashboard as root
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9AD1F5), // Pastel sky blue accent
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
                  child: const Center(
                    child: Text(
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

              const SizedBox(height: 32),

              // REDIRECT ROUTE TO SIGN UP PAGE
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Pushes over to your signup template layout
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
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFE8EDFF),
                ),
                child: const Icon(
                  Icons.show_chart,
                  color: Color(0xFF355CFF),
                  size: 28,
                ),
              ),

              const Text(
                "Join StockWave",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),
              const Text(
                "Embark on your investment journey with a single dollar.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // Username
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF355CFF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or continue with"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 20),

              // Google Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/g.png", height: 22),
                    const SizedBox(width: 10),
                    const Text("Continue with Google"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Apple Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/a.png", height: 22),
                    const SizedBox(width: 10),
                    const Text("Continue with Apple"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Already have an account? "),
                  Text("Sign In", style: TextStyle(color: Color(0xFF355CFF))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../models/app_user.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  // Controllers for text fields
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // Validate user inputs
  bool validateInputs() {

    if (nameController.text.trim().isEmpty) {
      showMessage("Please enter your name");
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      showMessage("Please enter your email");
      return false;
    }

    if (passwordController.text.isEmpty) {
      showMessage("Please enter your password");
      return false;
    }

    if (passwordController.text.length < 6) {
      showMessage("Password must be at least 6 characters");
      return false;
    }

    if (confirmPasswordController.text.isEmpty) {
      showMessage("Please confirm your password");
      return false;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage("Passwords do not match");
      return false;
    }

    return true;
  }

  // Show validation or error message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Register user using AuthProvider
  Future<void> handleSignUp() async {

    if (!validateInputs()) return;

    // Get AuthProvider
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    // Create AppUser object
    AppUser user = AppUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
    );

    // Call signUp function
    bool success = await authProvider.signUp(
      user,
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {

      // Navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      showMessage("Account created successfully!");

    } else {

      // Show Firebase error
      showMessage(
        authProvider.errorMessage ?? "Registration failed",
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            children: [

              Image.asset(
                "assets/logo/logo1.jfif",
                width: 200,
              ),

              const SizedBox(height: 20),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                hint: "Full Name",
                icon: Icons.person_outline,
                controller: nameController,
              ),

              CustomTextField(
                hint: "Email",
                icon: Icons.email_outlined,
                controller: emailController,
              ),

              CustomTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),

              CustomTextField(
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: confirmPasswordController,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: Consumer<AuthProvider>(
                  builder: (context, auth, child) {

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),

                      onPressed: auth.isLoading
                          ? null
                          : handleSignUp,

                      child: auth.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Verify Your Email"),
            content: const Text("A verification link has been sent to your email."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }

      Navigator.pop(context); // Navigate back to login
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      _showErrorDialog(message);
    } catch (e) {
      _showErrorDialog("An unexpected error occurred. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'An unexpected error occurred. [$code]';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - screenHeight * 0.04,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.jpeg',
                        height: screenHeight * 0.2,
                        width: screenHeight * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: screenHeight * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: firstNameController,
                      validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                      decoration: _inputDecoration('First Name', Icons.person),
                    ),
                    TextFormField(
                      controller: lastNameController,
                      validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                      decoration: _inputDecoration('Last Name', Icons.person_outline),
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) => value!.isEmpty || !value.contains('@')
                          ? 'Enter valid email'
                          : null,
                      decoration: _inputDecoration('Email', Icons.email),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      decoration: _inputDecorationWithToggle('Password', Icons.lock, () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      }, obscurePassword),
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      validator: (value) =>
                          value != passwordController.text ? 'Passwords do not match' : null,
                      decoration: _inputDecorationWithToggle('Confirm Password', Icons.lock_outline, () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      }, obscureConfirmPassword),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE66A6C),
                              foregroundColor: Colors.white,
                              minimumSize: Size(screenWidth * 0.8, screenHeight * 0.065),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text('Create Account'),
                          ),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFFE66A6C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _inputDecorationWithToggle(
      String label, IconData icon, VoidCallback toggleVisibility, bool obscure) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggleVisibility,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

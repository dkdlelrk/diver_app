import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 아이콘 사용을 위해 추가

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x806a11cb), Color(0x802575fc)], // 그라디언트 색상 설정
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Gradient Overlay for a modern look
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Positioned Text with Modern Style
            Positioned(
              top: 60,
              left: 50,
              child: Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/diverLogo.png'),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 200),
                        // Email Input Field
                        _buildTextField(
                          label: 'Input Your Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        // Password Input Field
                        _buildTextField(
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        // Modern Styled Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Perform login action
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showSignUp(context);
                          },
                          child: const Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Not a member? ',
                                style: TextStyle(fontSize: 23, color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign up now',
                                    style: TextStyle(fontSize: 23, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Social Media Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialButton(
                              icon: FontAwesomeIcons.google,
                              color: Colors.redAccent,
                              onTap: () {},
                            ),
                            _buildSocialButton(
                              icon: FontAwesomeIcons.comment,
                              color: const Color(0xFFFEE500),
                              onTap: () {},
                            ),
                            _buildSocialButton(
                              icon: FontAwesomeIcons.n,
                              color: const Color(0xFF03C75A),
                              onTap: () {},
                            ),
                            _buildSocialButton(
                              icon: FontAwesomeIcons.instagram,
                              color: Colors.pinkAccent,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Text Field Builder
  Widget _buildTextField({required String label, IconData? icon, bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _signUpTextField({required String label, IconData? icon, bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  showSignUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                _signUpTextField(
                  label: 'Nick Name',
                  icon: Icons.account_box_rounded,
                ),
                const SizedBox(height: 15),
                _signUpTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 15),
                _signUpTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                        emailFocusNode.dispose();
                        passwordFocusNode.dispose();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                        emailFocusNode.dispose();
                        passwordFocusNode.dispose();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      FocusScope.of(context).unfocus();
    });
  }

  // Social Button Builder
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: FaIcon(icon, color: color, size: 30),
      onPressed: onTap,
    );
  }
}

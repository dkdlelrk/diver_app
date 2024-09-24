import 'package:diver/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 아이콘 사용을 위해 추가

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passWordTextController = TextEditingController();
  final nickNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  // FocusNode 추가
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  String nickName = '';
  String email = '';
  String phone = '';
  String password = '';

  final _authentication = FirebaseAuth.instance;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  void dispose() {
    // FocusNode 해제
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
                  colors: [Color(0x806a11cb), Color(0x802575fc)],
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
            // 로고 이미지
            Positioned(
              top: 60,
              left: 50,
              child: Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/diverLogo.png'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.8), Colors.black54.withOpacity(0.4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54.withOpacity(0.2), Colors.blue.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 447,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 146,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  /*borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(80),
                    topLeft: Radius.circular(80),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                  ),*/
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  Text(
                    'PADI',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Giant Scuba Club',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            //
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStyledButton(
                      text: 'Login',
                      onPressed: () {
                        // _tryValidation();
                        _showLoginDialog(context);
                      },
                    ),
                    const SizedBox(width: 30),
                    _buildStyledButton(
                      text: 'SignUp',
                      onPressed: () {
                        //_tryValidation();
                        _showSignupDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Styled Button Builder
  Widget _buildStyledButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 150, // 버튼의 가로 크기 설정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Colors.blue, strokeAlign: 10),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final loginFormKey = GlobalKey<FormState>();
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
                  'Login State',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  key: loginFormKey,
                  child: Column(
                    children: [
                      _loginTextField(
                        label: 'Email',
                        controller: emailTextController,
                        icon: Icons.email_outlined,
                        obscureText: false,
                        filedCheckText: 'Email',
                      ),
                      _loginTextField(
                        label: 'PassWord',
                        controller: passWordTextController,
                        icon: Icons.password_outlined,
                        obscureText: true,
                        filedCheckText: 'PassWord',
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Your Password?"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (loginFormKey.currentState!.validate()) {
                          loginFormKey.currentState!.save();
                          try {
                            await _authentication.signInWithEmailAndPassword(
                                email: email.trim(), password: password.trim());

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const MainScreen();
                                },
                              ),
                            );
                          } catch (e) {
                            // 에러 메시지 표시
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                            debugPrint('Error: ${e.toString()}');
                          }

                          Navigator.of(context).pop();
                          emailTextController.clear();
                          passWordTextController.clear();
                        } else {
                          return null;
                        }
                      },
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        emailTextController.clear();
                        passWordTextController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Exit'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('OR'),
                const SizedBox(
                  height: 15,
                ),
                const Text('Social Login Zone'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSignupDialog(BuildContext context) {
    final signUpKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SignUp State',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: signUpKey,
                    child: Column(
                      children: [
                        _loginTextField(
                            label: 'NickName',
                            controller: nickNameTextController,
                            icon: Icons.drive_file_rename_outline,
                            obscureText: false,
                            filedCheckText: 'NickName'),
                        _loginTextField(
                            label: 'Email',
                            controller: emailTextController,
                            icon: Icons.email_outlined,
                            obscureText: false,
                            filedCheckText: 'Email'),
                        _loginTextField(
                          label: 'Phone',
                          controller: phoneTextController,
                          icon: Icons.phone_android,
                          obscureText: false,
                          filedCheckText: 'Phone',
                        ),
                        _loginTextField(
                          label: 'PassWord',
                          controller: passWordTextController,
                          icon: Icons.password_outlined,
                          obscureText: true,
                          filedCheckText: 'PassWord',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (signUpKey.currentState!.validate()) {
                            signUpKey.currentState!.save();
                            try {
                              await _authentication.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              Navigator.of(context).pop();
                              emailTextController.clear();
                              passWordTextController.clear();
                              phoneTextController.clear();
                              nickNameTextController.clear();
                            } catch (e) {
                              // 에러 메시지 표시
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.toString()}')),
                              );
                              debugPrint('Error: ${e.toString()}');
                            }
                          }
                        },
                        child: const Text('  SignUp  '),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          emailTextController.clear();
                          passWordTextController.clear();
                          phoneTextController.clear();
                          nickNameTextController.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('     Exit     '),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('OR'),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('Social Login Zone'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginTextField({
    required String label,
    required TextEditingController? controller,
    required String filedCheckText,
    IconData? icon,
    bool obscureText = false,
  }) {
    bool isValidEmail(String email) {
      final regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return regex.hasMatch(email.toString());
    }

    bool isValidPhoneNumber(String phone) {
      final regex = RegExp(
        r'^[0-9]+$',
      );
      return regex.hasMatch(phone.toString());
    }

    return TextFormField(
      controller: controller,
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
      onSaved: (text) {
        switch (filedCheckText) {
          case 'PassWord':
            password = text.toString();

          case 'NickName':
            nickName = text.toString();
            break;
          case 'Email':
            email = text.toString();
            break;
          case 'Phone':
            phone = text.toString();
            break;
        }
      }, //NickName,Email,Phone,PassWord
      validator: (value) {
        switch (filedCheckText) {
          case 'PassWord':
            if (value.toString().length < 6) {
              return 'Please enter PassWord is Short';
            }
          case 'NickName':
            if (value.toString().length < 2) {
              return 'Please enter NickName is Short';
            }
            break;
          case 'Email':
            if (!isValidEmail(value.toString())) {
              return 'Not a Email';
            }
            break;
          case 'Phone':
            if (!isValidPhoneNumber(value.toString())) {
              return 'Not a Phone';
            } else if (value.toString().length < 11 || value.toString().length > 13) {
              return 'Not a Phone';
            }
            break;
        }
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}

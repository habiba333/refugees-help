import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:refugees_help/main.dart';
import 'package:refugees_help/screens/main_screen.dart';
import 'package:refugees_help/screens/register_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xffCFD8DC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      'مرحبا!',
                      style: TextStyle(
                        color: Color(0xff506169),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Image.asset(
                      'assets/images/friends.png',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff2f9fc),
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'البريد الإلكتروني',
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك قم بإدخال البريد الاكتروني ';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                          return 'من فضلك ادخل البريد الاكتروني بطريقة صحيحة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff2f9fc),
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'كلمة المرور',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          icon: Icon(
                            isPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضبك ادخل كلمة المرور';
                        }
                        if (passwordController.text.length < 8) {
                          return 'كلمة المرور يجب ان تتكون من 8 أحرف او أرقام علي الأقل';
                        }
                        return null;
                      },
                      obscureText: isPassword,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff506169),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ));
                      },
                      child: const Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
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

  void login() {
    final usersBox = Hive.box('users');
    final email = emailController.text.trim();
    final password = passwordController.text;
    final user = usersBox.get(email);

    if (user == null || user['password'] != password) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('البيانات غير صالحة'),
          content: const Text('البريد الاكتروني او كلمة المرور غير صحيح'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
      emailController.clear();
      passwordController.clear();
    } else {
      loggedUser = email;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }
}

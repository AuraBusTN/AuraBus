import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/features/login/widgets/clickable_text.dart';
import 'package:aurabus/features/login/widgets/generic_button.dart';
import 'package:aurabus/features/login/widgets/google_button.dart';
import 'package:aurabus/features/login/widgets/custom_text_field.dart';
import 'package:aurabus/features/login/widgets/fade_in_slide.dart';
import 'package:aurabus/routing/router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print("Login valid: ${emailController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),

                      FadeInSlide(
                        delay: 0.1,
                        child: Column(
                          children: [
                            Hero(
                              tag: 'app_logo',
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                height: 90,
                                errorBuilder: (c, e, s) => Icon(
                                  Icons.directions_bus,
                                  size: 80,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Welcome Back!",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to continue your journey",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      FadeInSlide(
                        delay: 0.2,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              controller: passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Password is required'
                                  : null,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Clickabletext(
                                textlabel: "Forgot Password?",
                                fun: () {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      FadeInSlide(
                        delay: 0.3,
                        child: Column(
                          children: [
                            Genericbutton(
                              textlabel: 'Login',
                              onPressed: _handleLogin,
                            ),

                            const SizedBox(height: 30),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey.shade300),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    "Or continue with",
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey.shade300),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            Googlebutton(
                              onPressed: () {
                                print("Google Login");
                              },
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: FadeInSlide(
                delay: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoute.signup),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/common/widgets/clickable_text.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/common/widgets/google_button.dart';
import 'package:aurabus/common/widgets/custom_text_field.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';
import 'package:aurabus/routing/router.dart';
import 'package:aurabus/l10n/app_localizations.dart';

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
      // TODO: Implement login logic
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;

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
                              l10n.welcomeBack,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.signInSubtitle,
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
                              key: const Key('emailField'),
                              controller: emailController,
                              label: l10n.emailLabel,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.requiredField;
                                }
                                // Simple email validation
                                // TODO: Replace with more robust validation
                                if (!value.contains('@')) {
                                  return l10n.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              key: const Key('passwordField'),
                              controller: passwordController,
                              label: l10n.passwordLabel,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? l10n.requiredField
                                  : null,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: ClickableText(
                                textLabel: l10n.forgotPassword,
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
                            GenericButton(
                              textLabel: l10n.loginButton,
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
                                    l10n.continueWith,
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

                            GoogleButton(
                              onPressed: () {
                                // TODO: Implement Google Sign-In
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
                        l10n.noAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoute.signup),
                        child: Text(
                          l10n.signUpLink,
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

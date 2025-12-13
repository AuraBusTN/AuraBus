import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/common/widgets/google_button.dart';
import 'package:aurabus/common/widgets/custom_text_field.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool termsChecked = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (!termsChecked) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.termsError)));
        return;
      }
      // TODO: Implement signup logic
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
                      const SizedBox(height: 80),

                      FadeInSlide(
                        delay: 0.1,
                        child: Column(
                          children: [
                            Text(
                              l10n.createAccountTitle,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.createAccountSubtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      FadeInSlide(
                        delay: 0.2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: firstNameController,
                                    label: l10n.firstNameLabel,
                                    icon: Icons.person_outline,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? l10n.requiredField
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: CustomTextField(
                                    controller: lastNameController,
                                    label: l10n.lastNameLabel,
                                    icon: Icons.person_outline,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? l10n.requiredField
                                        : null,
                                  ),
                                ),
                              ],
                            ),

                            CustomTextField(
                              controller: emailController,
                              label: l10n.emailLabel,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              // TODO: Replace with more robust validation
                              validator: (v) =>
                                  !v!.contains('@') ? l10n.invalidEmail : null,
                            ),

                            CustomTextField(
                              controller: passwordController,
                              label: l10n.passwordLabel,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              // TODO: Replace with more robust validation
                              validator: (v) =>
                                  v!.length < 6 ? l10n.passwordMinChars : null,
                            ),

                            CustomTextField(
                              controller: confirmPasswordController,
                              label: l10n.confirmPasswordLabel,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (v) => v != passwordController.text
                                  ? l10n.passwordMismatch
                                  : null,
                            ),
                          ],
                        ),
                      ),

                      FadeInSlide(
                        delay: 0.3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TermsAndConditions(
                                isChecked: termsChecked,
                                onChanged: (val) =>
                                    setState(() => termsChecked = val ?? false),
                              ),
                            ),

                            GenericButton(
                              textLabel: l10n.signupButton,
                              onPressed: _handleSignup,
                            ),

                            const SizedBox(height: 25),

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
                                    l10n.orSignUpWith,
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

                            const SizedBox(height: 25),

                            GoogleButton(onPressed: () {}),

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
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: FadeInSlide(
                  delay: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            l10n.loginButton,
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
            ),
          ],
        ),
      ),
    );
  }
}

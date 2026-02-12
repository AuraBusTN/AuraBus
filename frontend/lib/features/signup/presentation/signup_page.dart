import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/common/widgets/generic_button.dart';
import 'package:aurabus/common/widgets/custom_text_field.dart';
import 'package:aurabus/features/signup/widgets/terms_and_conditions.dart';
import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/routing/router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).signup(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      context.go(AppRoute.account);
    } else {
      final error = ref.read(authProvider).error ?? "Registration failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),

                /// ---------- TEXT FIELDS ----------
                CustomTextField(
                  controller: firstNameController,
                  label: l10n.firstNameLabel,
                  icon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.requiredField : null,
                ),
                CustomTextField(
                  controller: lastNameController,
                  label: l10n.lastNameLabel,
                  icon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.requiredField : null,
                ),
                CustomTextField(
                  controller: emailController,
                  label: l10n.emailLabel,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || !_emailRegex.hasMatch(v.trim()))
                          ? l10n.invalidEmail
                          : null,
                ),
                CustomTextField(
                  controller: passwordController,
                  label: l10n.passwordLabel,
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6)
                          ? l10n.passwordMinChars
                          : null,
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: l10n.confirmPasswordLabel,
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return l10n.requiredField;
                    }
                    return v != passwordController.text
                        ? l10n.passwordMismatch
                        : null;
                  },
                ),

                const SizedBox(height: 20),

                /// ---------- TERMS FORM FIELD ----------
                FormField<bool>(
                  initialValue: false,
                  validator: (value) {
                    if (value != true) {
                      return l10n.termsError;
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TermsAndConditions(
                          isChecked: state.value ?? false,
                          onChanged: (val) {
                            state.didChange(val);
                          },
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// ---------- SIGNUP BUTTON ----------
                isLoading
                    ? const CircularProgressIndicator()
                    : GenericButton(
                        textLabel: l10n.signupButton,
                        onPressed: _handleSignup,
                      ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

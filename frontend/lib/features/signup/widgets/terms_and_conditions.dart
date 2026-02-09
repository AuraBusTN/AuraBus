import 'package:aurabus/routing/router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditions extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const TermsAndConditions({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push(AppRoute.terms);
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push(AppRoute.privacy);
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onChanged(!widget.isChecked);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isChecked ? primaryColor.withValues(alpha: 0.05) : Colors.white,
          border: Border.all(
            color: widget.isChecked ? primaryColor : Colors.grey.shade300,
            width: widget.isChecked ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: widget.isChecked
              ? [
                  BoxShadow(
                    color: tertiary.withAlpha(38), 
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: widget.isChecked ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isChecked ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: widget.isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isChecked ? Colors.black87 : Colors.grey[600],
                    height: 1.4,
                    fontFamily:
                        Theme.of(context).textTheme.bodyMedium?.fontFamily,
                  ),
                  children: [
                    TextSpan(text: l10n.termsText),
                    TextSpan(
                      text: l10n.termsLink,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _termsRecognizer,
                    ),
                    TextSpan(text: l10n.andText),
                    TextSpan(
                      text: l10n.privacyLink,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _privacyRecognizer,
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
}

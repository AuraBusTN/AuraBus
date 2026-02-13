import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class TermsAndConditions extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const TermsAndConditions({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!isChecked);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isChecked
              ? primaryColor.withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: isChecked ? primaryColor : Colors.grey.shade300,
            width: isChecked ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isChecked
              ? [
                  BoxShadow(
                    color: tertiary.withValues(alpha: 0.15),
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
                color: isChecked ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isChecked ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: isChecked ? Colors.black87 : Colors.grey[600],
                    height: 1.4,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontFamily,
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
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Open Terms and Conditions link
                        },
                    ),
                    TextSpan(text: l10n.andText),
                    TextSpan(
                      text: l10n.privacyLink,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Open Privacy Policy link
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
}

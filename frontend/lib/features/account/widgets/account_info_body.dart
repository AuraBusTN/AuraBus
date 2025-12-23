import 'package:flutter/material.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class AccountInfoBody extends StatelessWidget {
  final bool busNotificationEnabled;
  final ValueChanged<bool> onNotificationToggle;
  final String firstName;
  final String lastName;
  final String email;

  const AccountInfoBody({
    super.key,
    required this.busNotificationEnabled,
    required this.onNotificationToggle,
    this.firstName = "John",
    this.lastName = "Doe",
    this.email = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  email.isNotEmpty
                      ? email
                      : AppLocalizations.of(context)!.editProfilePicture,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.busNotificationLabel),
            Switch(
              value: busNotificationEnabled,
              onChanged: onNotificationToggle,
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

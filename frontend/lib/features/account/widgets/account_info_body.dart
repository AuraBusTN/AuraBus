import 'package:flutter/material.dart';
import 'package:aurabus/l10n/app_localizations.dart';

class AccountInfoBody extends StatelessWidget {
  final bool busNotificationEnabled;
  final ValueChanged<bool> onNotificationToggle;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  const AccountInfoBody({
    super.key,
    required this.busNotificationEnabled,
    required this.onNotificationToggle,
    this.firstName = "John",
    this.lastName = "Doe",
    this.email = "",
    this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider =
        (profilePictureUrl != null && profilePictureUrl!.isNotEmpty)
        ? NetworkImage(profilePictureUrl!)
        : const AssetImage('assets/images/profile_pic.png') as ImageProvider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Colors.grey.shade200,
              backgroundImage: imageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error if necessary
              },
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

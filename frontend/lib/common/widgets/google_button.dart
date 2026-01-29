import 'dart:async';

import 'package:aurabus/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/core/google_web_sign_in_button.dart';

class GoogleButton extends ConsumerStatefulWidget {
  final VoidCallback? onPressed;

  const GoogleButton({super.key, this.onPressed});

  @override
  ConsumerState<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends ConsumerState<GoogleButton> {
  bool _webReady = !kIsWeb;
  StreamSubscription<AuthenticationEvent>? _authEventsSub;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    _initWeb();
  }

  Future<void> _initWeb() async {
    if (!mounted) return;
    setState(() => _webReady = false);

    try {
      await ref.read(authProvider.notifier).ensureGoogleReadyForWeb();
      if (!mounted) return;
      setState(() => _webReady = true);
      _subscribeToAuthEvents();
    } catch (e) {
      ref.read(authProvider.notifier).setAuthError(e.toString());
      if (!mounted) return;
      setState(() => _webReady = false);
    }
  }

  void _subscribeToAuthEvents() {
    final events = GoogleSignInPlatform.instance.authenticationEvents;
    if (events == null) return;

    _authEventsSub ??= events.listen((event) async {
      if (!mounted) return;

      if (event is AuthenticationEventSignIn) {
        final idToken = event.authenticationTokens.idToken;
        if (idToken == null || idToken.trim().isEmpty) {
          ref
              .read(authProvider.notifier)
              .setAuthError('Google sign-in did not return an ID token');
          return;
        }
        await ref.read(authProvider.notifier).loginWithGoogleIdToken(idToken);
        return;
      }

      if (event is AuthenticationEventException) {
        final ex = event.exception;
        if (ex.code == GoogleSignInExceptionCode.canceled) {
          ref.read(authProvider.notifier).setAuthError(null);
          return;
        }
        ref
            .read(authProvider.notifier)
            .setAuthError(ex.description ?? ex.toString());
      }
    });
  }

  @override
  void dispose() {
    _authEventsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (!_webReady) {
        return const SizedBox(
          height: 55,
          width: double.infinity,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return SizedBox(
        height: 55,
        width: double.infinity,
        child: renderGoogleSignInButton(),
      );
    }

    return SizedBox(
      height: 55,
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: widget.onPressed,
        icon: Image.asset(
          'assets/images/google_48x48.png',
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
        ),
        label: Text(
          AppLocalizations.of(context)!.signInWithGoogle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

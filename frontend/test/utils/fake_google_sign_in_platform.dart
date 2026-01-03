import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class FakeGoogleSignInPlatform extends GoogleSignInPlatform {
  InitParameters? lastInitParameters;
  AuthenticateParameters? lastAuthenticateParameters;

  AuthenticationResults? nextAuthenticateResult;
  GoogleSignInException? nextAuthenticateException;

  bool initialized = false;

  @override
  Future<void> init(InitParameters params) async {
    initialized = true;
    lastInitParameters = params;
  }

  @override
  Future<AuthenticationResults?> attemptLightweightAuthentication(
    AttemptLightweightAuthenticationParameters params,
  ) async {
    return null;
  }

  @override
  bool supportsAuthenticate() => true;

  @override
  Future<AuthenticationResults> authenticate(
    AuthenticateParameters params,
  ) async {
    lastAuthenticateParameters = params;

    final exception = nextAuthenticateException;
    if (exception != null) {
      throw exception;
    }

    final result = nextAuthenticateResult;
    if (result == null) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'FakeGoogleSignInPlatform: no result configured',
      );
    }

    return result;
  }

  @override
  bool authorizationRequiresUserInteraction() => false;

  @override
  Future<ClientAuthorizationTokenData?> clientAuthorizationTokensForScopes(
    ClientAuthorizationTokensForScopesParameters params,
  ) async {
    return null;
  }

  @override
  Future<ServerAuthorizationTokenData?> serverAuthorizationTokensForScopes(
    ServerAuthorizationTokensForScopesParameters params,
  ) async {
    return null;
  }

  @override
  Future<void> signOut(SignOutParams params) async {}

  @override
  Future<void> disconnect(DisconnectParams params) async {}
}

AuthenticationResults buildFakeAuthenticationResults({
  required String email,
  required String userId,
  String? displayName,
  String? photoUrl,
  required String? idToken,
}) {
  return AuthenticationResults(
    user: GoogleSignInUserData(
      email: email,
      id: userId,
      displayName: displayName,
      photoUrl: photoUrl,
    ),
    authenticationTokens: AuthenticationTokenData(idToken: idToken),
  );
}

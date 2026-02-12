import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  Future<String> loadTerms(BuildContext context) async {
      final l10n = AppLocalizations.of(context)!;
      return await rootBundle.loadString(l10n.termsdirectory);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsLink),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(); 
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: loadTerms(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.termsLoadError));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              snapshot.data ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}

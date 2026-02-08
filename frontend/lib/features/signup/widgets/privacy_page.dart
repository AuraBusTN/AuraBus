import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  Future<String> loadPrivacy() async {
    return await rootBundle.loadString('assets/terms&privacy/privacy.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Torna indietro al signup
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: loadPrivacy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Errore nel caricamento della Privacy Policy"));
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  Future<String> loadTerms() async {
    return await rootBundle.loadString('assets/terms&privacy/terms.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: loadTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Errore nel caricamento dei Terms"));
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

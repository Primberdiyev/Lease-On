import 'package:flutter/material.dart';
import 'package:rentora/feature/home/ask_law_page.dart';
import 'package:rentora/feature/utils/law_model.dart';
import 'package:rentora/feature/utils/laws.dart';

class LawyerPage extends StatelessWidget {
  const LawyerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qonunlar Bazasi'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: laws.length,
        itemBuilder: (context, index) {
          final law = laws[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                law.lawName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                law.lawDescription.join(', '),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    law.fullLaw,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AskLawPage()));
        },
        child: Icon(
          Icons.help_outline,
          color: Colors.white,
        ),
      ),
    );
  }
}

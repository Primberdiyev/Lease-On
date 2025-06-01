import 'package:flutter/material.dart';
import 'package:rentora/feature/utils/law_model.dart';
import 'package:rentora/feature/utils/laws.dart';

class AskLawPage extends StatefulWidget {
  const AskLawPage({super.key});

  @override
  State<AskLawPage> createState() => _AskLawPageState();
}

class _AskLawPageState extends State<AskLawPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _controller.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Process and respond after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _findRelevantLaws(text);
    });
  }

  void _findRelevantLaws(String query) {
    final queryWords = query.toLowerCase().split(' ');
    final matchedLaws = <LawModel>[];

    for (final law in laws) {
      // Calculate match score
      int score = 0;

      // Check description keywords
      for (final keyword in law.lawDescription) {
        if (queryWords.any((word) => word.contains(keyword.toLowerCase()))) {
          score++;
        }
      }

      // Check law name
      if (law.lawName.toLowerCase().contains(query.toLowerCase())) {
        score += 2; // Higher weight for name matches
      }

      if (score > 0) {
        matchedLaws.add(law);
      }
    }

    // Sort by relevance (higher score first)
    matchedLaws.sort((a, b) {
      final scoreA = _calculateMatchScore(a, query);
      final scoreB = _calculateMatchScore(b, query);
      return scoreB.compareTo(scoreA);
    });

    setState(() {
      if (matchedLaws.isEmpty) {
        _messages.add({
          'text':
              "Kechirasiz, siz so'ragan mavzuga oid qonun topilmadi. Iltimos, boshqa kalit so'zlar yordamida yozib ko'ring.",
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      } else {
        // Take only top 2 most relevant laws
        final lawsToShow = matchedLaws.take(2).toList();

        _messages.add({
          'text': "Sizga quyidagi qonunlarni taklif qilamiz:",
          'isUser': false,
          'timestamp': DateTime.now(),
          'isHeader': true,
        });

        for (final law in lawsToShow) {
          _messages.add({
            'text': law.lawName,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isLawTitle': true,
          });
          _messages.add({
            'text': law.fullLaw,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isLawContent': true,
          });
        }

        if (matchedLaws.length > 2) {
          _messages.add({
            'text':
                "Yana ${matchedLaws.length - 2} ta tegishli qonun topildi. Aniqroq so'rov yuboring.",
            'isUser': false,
            'timestamp': DateTime.now(),
            'isFooter': true,
          });
        }
      }
    });

    // Scroll to bottom after adding messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  int _calculateMatchScore(LawModel law, String query) {
    final queryWords = query.toLowerCase().split(' ');
    int score = 0;

    // Check description keywords
    for (final keyword in law.lawDescription) {
      if (queryWords.any((word) => word.contains(keyword.toLowerCase()))) {
        score++;
      }
    }

    // Check law name
    if (law.lawName.toLowerCase().contains(query.toLowerCase())) {
      score += 2; // Higher weight for name matches
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Huquqiy Yordam'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'] as bool;
                final isHeader = message['isHeader'] == true;
                final isLawTitle = message['isLawTitle'] == true;
                final isLawContent = message['isLawContent'] == true;
                final isFooter = message['isFooter'] == true;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue[100]
                          : (isHeader || isFooter
                              ? Colors.blue[50]
                              : (isLawTitle || isLawContent
                                  ? Colors.white
                                  : Colors.grey[100])),
                      borderRadius: BorderRadius.circular(12),
                      border: isLawTitle || isLawContent
                          ? Border.all(color: Colors.grey[300]!)
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isHeader)
                          Text(
                            message['text'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          )
                        else if (isFooter)
                          Text(
                            message['text'],
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          )
                        else if (isLawTitle)
                          Text(
                            message['text'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          )
                        else if (isLawContent)
                          Text(
                            message['text'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.justify,
                          )
                        else
                          Text(
                            message['text'],
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.grey[800],
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message['timestamp']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 30,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Huquqiy masalangizni yozing...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  iconSize: 50,
                  onPressed: _sendMessage,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

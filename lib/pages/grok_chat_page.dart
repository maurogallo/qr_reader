import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/grok_provider.dart';

class GrokChatPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  GrokChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final grokProvider = Provider.of<GrokProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con Grok'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => grokProvider.clearChat(),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: grokProvider.messages.length,
              itemBuilder: (context, index) {
                final msg = grokProvider.messages[index];
                final isUser = msg['role'] == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.deepPurple : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        msg['content'] ?? '',
                        style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (grokProvider.isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Pregúntale a Grok...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (value) {
                       if (value.isNotEmpty) {
                        grokProvider.sendMessage(value);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      grokProvider.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

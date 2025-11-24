import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrokProvider extends ChangeNotifier {
  // ⚠️ IMPORTANTE: Nunca subas tu API Key real a repositorios públicos.
  // Considera usar flutter_dotenv para manejar variables de entorno.
  final String _apiKey = 'TU_API_KEY_DE_GROK_AQUI'; 
  final String _baseUrl = 'https://api.x.ai/v1/chat/completions';

  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  List<Map<String, String>> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Añadir mensaje del usuario
    _messages.add({'role': 'user', 'content': content});
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'grok-beta', // Asegúrate de usar el modelo correcto disponible
          'messages': _messages,
          'stream': false, // Simplificado para este ejemplo (sin streaming)
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
           final botContent = data['choices'][0]['message']['content'];
           _messages.add({'role': 'assistant', 'content': botContent});
        }
      } else {
        _messages.add({
          'role': 'assistant',
          'content': 'Error al conectar con Grok: ${response.statusCode}'
        });
        debugPrint('Error Grok API: ${response.body}');
      }
    } catch (e) {
      _messages.add({'role': 'assistant', 'content': 'Error de conexión: $e'});
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}

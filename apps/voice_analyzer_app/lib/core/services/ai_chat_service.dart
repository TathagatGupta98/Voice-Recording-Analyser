import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/transcript_database.dart';

class AiChatService {
  
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  AiChatService();

  Future<String> queryAgent(String userQuery) async {
    final localData = await TranscriptDatabase.instance.fetchAllTranscripts();
    
    final formattedContext = localData.map((t) {
      return "[Transcript Date: ${t['timestamp']}]\n${t['text']}";
    }).join('\n\n---\n\n');

    final systemInstruction = 
        "You are an intelligent call assistant. You have access to the user's call recordings and transcriptions. "
        "Use the following transcribed context to accurately answer the user's request. If the context does not contain "
        "the answer, rely on your knowledge base but explicitly state that it wasn't found in the call logs.\n\n"
        "### AVAILABLE CALL TRANSCRIPTS ###\n$formattedContext";

    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': '$systemInstruction\n\nUser Query: $userQuery'}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      throw Exception('Failed to get a response from the AI Agent layer: ${response.body}');
    }
  }
}
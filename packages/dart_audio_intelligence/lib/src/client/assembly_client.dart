import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/transcript_response.dart';

class AudioIntelligenceClient {
  final String _apiKey;
  static const String _baseUrl = 'https://api.assemblyai.com/v2';

  AudioIntelligenceClient(this._apiKey);

  Map<String, String> get _headers => {
        'authorization': _apiKey,
        'content-type': 'application/json',
      };

  /// Uploads a local audio file and returns the upload URL
  Future<String> uploadAudio(File audioFile) async {
    final request = http.Request('POST', Uri.parse('$_baseUrl/upload'))
      ..headers.addAll(_headers)
      ..bodyBytes = await audioFile.readAsBytes();

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);
    
    return json['upload_url'];
  }

  /// Initiates transcription and polls until completion
  Future<TranscriptResponse> transcribe(String uploadUrl) async {
    // 1. Submit for transcription
    final submitRes = await http.post(
      Uri.parse('$_baseUrl/transcript'),
      headers: _headers,
      body: jsonEncode({'audio_url': uploadUrl}),
    );
    
    final submitJson = jsonDecode(submitRes.body);
    final transcriptId = submitJson['id'];

    // 2. Poll for completion
    while (true) {
      final pollRes = await http.get(
        Uri.parse('$_baseUrl/transcript/$transcriptId'),
        headers: _headers,
      );
      
      final pollJson = jsonDecode(pollRes.body);
      final status = TranscriptResponse.fromJson(pollJson);

      if (status.isCompleted || status.isError) {
        return status;
      }
      
      // Wait before polling again to respect API rate limits
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
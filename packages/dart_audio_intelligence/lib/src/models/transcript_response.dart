class TranscriptResponse {
  final String id;
  final String status;
  final String? text;
  final String? error;

  TranscriptResponse({
    required this.id,
    required this.status,
    this.text,
    this.error,
  });

  factory TranscriptResponse.fromJson(Map<String, dynamic> json) {
    return TranscriptResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      text: json['text'] as String?,
      error: json['error'] as String?,
    );
  }
  
  bool get isCompleted => status == 'completed';
  bool get isError => status == 'error';
}
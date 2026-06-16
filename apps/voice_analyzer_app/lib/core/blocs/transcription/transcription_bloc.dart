import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_audio_intelligence/dart_audio_intelligence.dart';
import '../../database/transcript_database.dart';
import 'transcription_event.dart';
import 'transcription_state.dart';

class TranscriptionBloc extends Bloc<TranscriptionEvent, TranscriptionState> {
  final AudioIntelligenceClient _apiClient;

  TranscriptionBloc(this._apiClient) : super(TranscriptionInitial()) {
    on<ProcessAudioFile>(_onProcessAudioFile);
  }

  Future<void> _onProcessAudioFile(
    ProcessAudioFile event,
    Emitter<TranscriptionState> emit,
  ) async {
    emit(TranscriptionInProgress());

    try {
      // 1. Upload the local file to AssemblyAI
      final uploadUrl = await _apiClient.uploadAudio(event.audioFile);

      // 2. Start transcription and poll for the result
      final result = await _apiClient.transcribe(uploadUrl);

      // 3. Emit the final state based on the package's response model
      if (result.isCompleted) {
        await TranscriptDatabase.instance.insertTranscript(result.id, result.text!);
        emit(TranscriptionSuccess(result));
      } else if (result.isError) {
        emit(TranscriptionFailure(result.error ?? 'Unknown API Error'));
      } else {
        emit(TranscriptionFailure('Transcription timed out or failed.'));
      }
    } catch (e) {
      emit(TranscriptionFailure(e.toString()));
    }
  }
}
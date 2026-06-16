import 'package:equatable/equatable.dart';
import 'package:dart_audio_intelligence/dart_audio_intelligence.dart';

abstract class TranscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TranscriptionInitial extends TranscriptionState {}

class TranscriptionInProgress extends TranscriptionState {}

class TranscriptionSuccess extends TranscriptionState {
  final TranscriptResponse response;

  TranscriptionSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class TranscriptionFailure extends TranscriptionState {
  final String error;

  TranscriptionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class TranscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProcessAudioFile extends TranscriptionEvent {
  final File audioFile;

  ProcessAudioFile(this.audioFile);

  @override
  List<Object?> get props => [audioFile];
}
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendQueryEvent extends ChatEvent {
  final String query;

  SendQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
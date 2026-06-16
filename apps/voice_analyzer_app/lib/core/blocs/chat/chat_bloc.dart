import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/ai_chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AiChatService _aiChatService;

  ChatBloc(this._aiChatService) : super(ChatInitial()) {
    on<SendQueryEvent>(_onSendQueryEvent);
  }

  Future<void> _onSendQueryEvent(
    SendQueryEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final response = await _aiChatService.queryAgent(event.query);
      emit(ChatSuccess(response));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
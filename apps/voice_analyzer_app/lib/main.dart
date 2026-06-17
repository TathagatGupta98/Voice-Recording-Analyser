import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_audio_intelligence/dart_audio_intelligence.dart';
import 'core/blocs/transcription/transcription_bloc.dart';
import 'core/blocs/chat/chat_bloc.dart';
import 'core/services/ai_chat_service.dart';
import 'presentation/tabs/transcripts_tab.dart';
import 'presentation/tabs/chat_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TranscriptionBloc(
            AudioIntelligenceClient(dotenv.env['ASSEMBLYAI_API_KEY'] ?? ''),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(AiChatService()),
        ),
      ],
      child: MaterialApp(
        title: 'Voice Intelligence AI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voice Intelligence AI'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.description), text: 'Transcripts'),
              Tab(icon: Icon(Icons.smart_toy), text: 'AI Agent'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TranscriptsTab(), // First tab content
            ChatTab(),        // Second tab content
          ],
        ),
      ),
    );
  }
}

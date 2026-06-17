import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/transcription/transcription_bloc.dart';
import '../../core/blocs/transcription/transcription_event.dart';
import '../../core/blocs/transcription/transcription_state.dart';
import '../../core/services/audio_input_service.dart';

class TranscriptsTab extends StatelessWidget {
  const TranscriptsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = AudioInputService();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Upload Trigger Button
          ElevatedButton.icon(
            onPressed: () async {
              final file = await audioService.pickAudioFile();
              if (file != null && context.mounted) {
                context.read<TranscriptionBloc>().add(ProcessAudioFile(file));
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Call Recording'),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: BlocConsumer<TranscriptionBloc, TranscriptionState>(
              listener: (context, state) {
                if (state is TranscriptionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Audio processed successfully!')),
                  );
                }
              },
              builder: (context, state) {
                if (state is TranscriptionInProgress) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Uploading & analyzing audio... Please wait.'),
                      ],
                    ),
                  );
                }

                if (state is TranscriptionFailure) {
                  return Center(
                    child: Text('Error: ${state.error}', style: const TextStyle(color: Colors.red)),
                  );
                }

                if (state is TranscriptionSuccess) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Text(
                          state.response.text ?? 'No text generated.',
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ),
                  );
                }

                return const Center(
                  child: Text('Select an audio log above to kickstart transcription.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
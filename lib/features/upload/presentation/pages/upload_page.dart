import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/upload_bloc.dart';
import '../bloc/upload_event.dart';
import '../bloc/upload_state.dart';
import '../widgets/image_preview.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadBloc, UploadState>(
      builder: (context, state) {
        final file = switch (state) {
          UploadPicked(:final file) => file,
          UploadInProgress(:final file) => file,
          UploadSuccess(:final file) => file,
          UploadFailure(:final file) => file,
          _ => null,
        };
        final isUploading = state is UploadInProgress;
        final canUpload = file != null && !isUploading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImagePreview(imageFile: file),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.outline,
                      onPress: isUploading
                          ? null
                          : () => context.read<UploadBloc>().add(
                                ImagePicked(ImageSource.gallery),
                              ),
                      prefix: const Icon(FLucideIcons.imageUp),
                      child: const Text('Galeri'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.outline,
                      onPress: isUploading
                          ? null
                          : () => context.read<UploadBloc>().add(
                                ImagePicked(ImageSource.camera),
                              ),
                      prefix: const Icon(FLucideIcons.camera),
                      child: const Text('Kamera'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FButton(
                onPress: canUpload
                    ? () => context.read<UploadBloc>().add(
                          UploadSubmitted(useBase64: false),
                        )
                    : null,
                prefix: const Icon(FLucideIcons.cloudUpload),
                child: const Text('Upload Langsung (File Asli)'),
              ),
              const SizedBox(height: 8),
              FButton(
                onPress: canUpload
                    ? () => context.read<UploadBloc>().add(
                          UploadSubmitted(useBase64: true),
                        )
                    : null,
                prefix: const Icon(FLucideIcons.binary),
                child: const Text('Upload via Base64'),
              ),
              const SizedBox(height: 20),
              if (state is UploadFailure)
                Text(
                  state.message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              if (isUploading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (state is UploadSuccess) ...[
                const Text('Berhasil! URL gambar:'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        state.url,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FLucideIcons.externalLink),
                      tooltip: 'Buka link',
                      onPressed: () => _openUrl(context, state.url),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      showFToast(
        context: context,
        variant: FToastVariant.destructive,
        title: const Text('Gagal'),
        description: const Text('Tidak bisa membuka link ini.'),
      );
    }
  }
}
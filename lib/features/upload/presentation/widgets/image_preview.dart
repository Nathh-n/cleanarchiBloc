import 'dart:io';

import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.imageFile});

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: imageFile == null
            ? Icon(FLucideIcons.image, size: 48, color: outline)
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageFile!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';

enum CategoryTheme {
  academic,
  fiancee,
  finance,
  lifestyle,
  sleep,
}

class CategoryBackgroundWrapper extends StatefulWidget {
  final CategoryTheme category;
  final Widget child;
  final Uint8List? initialCustomImageBytes;
  final ValueChanged<Uint8List?>? onCustomImageChanged;
  final bool showImagePickerButton;

  const CategoryBackgroundWrapper({
    super.key,
    required this.category,
    required this.child,
    this.initialCustomImageBytes,
    this.onCustomImageChanged,
    this.showImagePickerButton = false,
  });

  @override
  State<CategoryBackgroundWrapper> createState() => _CategoryBackgroundWrapperState();
}

class _CategoryBackgroundWrapperState extends State<CategoryBackgroundWrapper> {
  Uint8List? _customImageBytes;

  @override
  void initState() {
    super.initState();
    _customImageBytes = widget.initialCustomImageBytes;
  }

  @override
  void didUpdateWidget(covariant CategoryBackgroundWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCustomImageBytes != oldWidget.initialCustomImageBytes) {
      _customImageBytes = widget.initialCustomImageBytes;
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _customImageBytes = bytes;
        });
        widget.onCustomImageChanged?.call(bytes);
      }
    } catch (e) {
      debugPrint('Error picking background image: $e');
    }
  }

  List<Color> _getGradient(bool isDark) {
    switch (widget.category) {
      case CategoryTheme.academic:
        return isDark
            ? AppColors.academicGradientDark
            : AppColors.academicGradientLight;
      case CategoryTheme.fiancee:
        return isDark
            ? AppColors.romanticGradientDark
            : AppColors.romanticGradientLight;
      case CategoryTheme.finance:
        return isDark
            ? AppColors.emeraldGradientDark
            : AppColors.emeraldGradientLight;
      case CategoryTheme.lifestyle:
        return isDark
            ? AppColors.neonGradientDark
            : AppColors.neonGradientLight;
      case CategoryTheme.sleep:
        return isDark
            ? AppColors.indigoGradientDark
            : AppColors.indigoGradientLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _getGradient(isDark);

    return Stack(
      children: [
        // Background layer: custom image or gradient
        if (_customImageBytes != null)
          Positioned.fill(
            child: Image.memory(
              _customImageBytes!,
              fit: BoxFit.cover,
            ),
          )
        else
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

        // Readability overlay / contrast scrim
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ),

        // Content
        Positioned.fill(child: widget.child),

        // Optional quick image picker button
        if (widget.showImagePickerButton)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'bg_picker_${widget.category.name}',
              onPressed: _pickImage,
              tooltip: 'Set Custom Wallpaper',
              child: const Icon(Icons.wallpaper),
            ),
          ),
      ],
    );
  }
}

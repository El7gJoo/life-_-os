import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/proof_service.dart';

class ProofCaptureDialog extends StatefulWidget {
  final String type; // 'attendance' or 'study'
  final String targetId; // sessionId or subjectId
  final String? subjectName;

  const ProofCaptureDialog({
    super.key,
    required this.type,
    required this.targetId,
    this.subjectName,
  });

  static Future<bool> show(
    BuildContext context, {
    required String type,
    required String targetId,
    String? subjectName,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProofCaptureDialog(
        type: type,
        targetId: targetId,
        subjectName: subjectName,
      ),
    );
    return result ?? false;
  }

  @override
  State<ProofCaptureDialog> createState() => _ProofCaptureDialogState();
}

class _ProofCaptureDialogState extends State<ProofCaptureDialog> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  Uint8List? _capturedImageBytes;
  String? _statusMessage;
  bool? _isSuccess;

  Future<void> _capturePhoto() async {
    final l10n = AppLocalizations.of(context);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      setState(() {
        _capturedImageBytes = bytes;
        _isProcessing = true;
        _statusMessage = l10n.loading;
        _isSuccess = null;
      });

      final proofService = getIt<ProofService>();
      final result = await proofService.verifyPhotoProof(
        imageBytes: bytes,
        type: widget.type,
        targetId: widget.targetId,
        subjectName: widget.subjectName,
      );

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _isSuccess = result.isValid;
        if (result.isValid) {
          _statusMessage = result.isOfflineQueued
              ? l10n.proofPendingOffline
              : l10n.proofVerified;
        } else {
          final failedAttempts = proofService.getTodayFailedAttempts(widget.targetId);
          final remaining = (3 - failedAttempts).clamp(0, 3);
          _statusMessage = l10n.proofUnclear(result.reason, remaining);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isSuccess = false;
          _statusMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            widget.type == 'attendance' ? Icons.school : Icons.menu_book,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.takeProof)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Privacy notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.privacy_tip_outlined, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.proofPrivacyNotice,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Image Preview or Camera Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: _capturedImageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _capturedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            widget.type == 'attendance'
                                ? 'Capture lecture hall, board, or campus'
                                : 'Capture notebook, desk, or study material',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
            ),

            if (_isProcessing) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _statusMessage ?? l10n.loading,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ] else if (_statusMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (_isSuccess == true ? AppColors.emeraldGreenLight : AppColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess == true ? Icons.check_circle : Icons.error,
                      color: _isSuccess == true ? AppColors.emeraldGreenLight : AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _isSuccess == true ? AppColors.emeraldGreenLight : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isProcessing && _isSuccess != true) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: Text(l10n.takeProof),
            onPressed: _capturePhoto,
          ),
        ] else if (_isSuccess == true) ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldGreenLight,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.close, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ],
    );
  }
}

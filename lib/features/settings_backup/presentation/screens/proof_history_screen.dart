import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/rtl_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/proof_service.dart';
import '../../../schedule_study/data/models/proof_log_model.dart';

class ProofHistoryScreen extends StatefulWidget {
  const ProofHistoryScreen({super.key});

  @override
  State<ProofHistoryScreen> createState() => _ProofHistoryScreenState();
}

class _ProofHistoryScreenState extends State<ProofHistoryScreen> {
  late List<ProofLogModel> _logs;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    setState(() {
      _logs = getIt<ProofService>().getProofLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.proofLogs),
        actions: [
          if (_logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.confirmDelete),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await getIt<ProofService>().clearProofLogs();
                  _loadLogs();
                }
              },
            ),
        ],
      ),
      body: _logs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noProofLogs,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                Color verdictColor;
                IconData verdictIcon;

                switch (log.verdict) {
                  case 'approved':
                  case 'location_verified':
                    verdictColor = AppColors.emeraldGreenLight;
                    verdictIcon = Icons.check_circle;
                    break;
                  case 'offline_queued':
                    verdictColor = AppColors.neonEnergyLight;
                    verdictIcon = Icons.cloud_queue;
                    break;
                  default:
                    verdictColor = AppColors.error;
                    verdictIcon = Icons.cancel;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  log.type == 'attendance' ? Icons.school : Icons.menu_book,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  log.type == 'attendance' ? l10n.lecture : l10n.schedule2,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: verdictColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(verdictIcon, size: 14, color: verdictColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    log.verdict.toUpperCase(),
                                    style: TextStyle(
                                      color: verdictColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          log.reason,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              RtlUtils.ltr(DateFormat('yyyy/MM/dd HH:mm').format(log.timestamp)),
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            if (log.photoHash != null)
                              Text(
                                'SHA: ${log.photoHash!.substring(0, 8)}...',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontFamily: 'Courier',
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

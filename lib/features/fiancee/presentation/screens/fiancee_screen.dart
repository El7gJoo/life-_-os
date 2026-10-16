import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings_backup/presentation/cubits/settings_cubit.dart';
import '../../data/models/gift_note_model.dart';
import '../../data/models/occasion_model.dart';
import '../cubits/fiancee_cubit.dart';
import '../cubits/fiancee_state.dart';

class FianceeScreen extends StatefulWidget {
  const FianceeScreen({super.key});

  @override
  State<FianceeScreen> createState() => _FianceeScreenState();
}

class _FianceeScreenState extends State<FianceeScreen> {
  String _selectedNoteCategory = 'all';

  Future<void> _authenticate(BuildContext context) async {
    final cubit = context.read<FianceeCubit>();
    if (kIsWeb) {
      // Web fallback: instant unlock
      cubit.setAuthenticated(true);
      return;
    }

    try {
      final localAuth = LocalAuthentication();
      final canCheck = await localAuth.canCheckBiometrics || await localAuth.isDeviceSupported();
      if (!canCheck) {
        cubit.setAuthenticated(true);
        return;
      }

      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access Fiancée Hub',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        cubit.setAuthenticated(true);
      }
    } catch (_) {
      // In case of error/simulator, provide fallback unlock
      cubit.setAuthenticated(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isBiometricEnabled = context.watch<SettingsCubit>().state.isBiometricEnabled;

    return CategoryBackgroundWrapper(
      category: CategoryTheme.fiancee,
      child: BlocBuilder<FianceeCubit, FianceeState>(
        builder: (context, state) {
          if (isBiometricEnabled && !state.isAuthenticated) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(l10n.fianceeHub),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 64,
                          color: AppColors.romanticRoseLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.fianceeHub,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.authenticateToAccess,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.romanticRoseLight,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.fingerprint, color: Colors.white),
                        label: Text(
                          l10n.authenticateToAccess,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _authenticate(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final filteredNotes = _selectedNoteCategory == 'all'
              ? state.notes
              : state.notes.where((n) => n.category == _selectedNoteCategory).toList();

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.fianceeHub),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_alert_outlined),
                  tooltip: l10n.addOccasion,
                  onPressed: () => _showAddOccasionDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.note_add_outlined),
                  tooltip: l10n.add,
                  onPressed: () => _showAddNoteDialog(context),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Quality time action card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite, color: AppColors.romanticRoseLight, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.qualityTime,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+15 points daily reward',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isQualityTimeCompletedToday
                                ? Colors.grey
                                : AppColors.romanticRoseLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: state.isQualityTimeCompletedToday
                              ? null
                              : () async {
                                  await HapticUtils.heavyImpact();
                                  if (context.mounted) {
                                    final messenger = ScaffoldMessenger.of(context);
                                    await context.read<FianceeCubit>().completeQualityTime();
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('Quality Time logged! +15 points earned ❤️'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            state.isQualityTimeCompletedToday ? l10n.done : l10n.done,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Occasions Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.occasions,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addOccasion),
                      onPressed: () => _showAddOccasionDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (state.occasions.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.noData,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...state.occasions.map((occasion) {
                    final days = AppDateUtils.daysUntil(occasion.nextOccurrence);
                    final isUpcoming = days >= 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                          child: Icon(
                            _getOccasionIcon(occasion.type),
                            color: AppColors.romanticRoseLight,
                          ),
                        ),
                        title: Text(
                          occasion.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${AppDateUtils.formatDisplayDate(occasion.nextOccurrence)}${occasion.repeatYearly ? ' • Yearly' : ''}${occasion.notes != null && occasion.notes!.isNotEmpty ? '\n${occasion.notes}' : ''}',
                        ),
                        isThreeLine: occasion.notes != null && occasion.notes!.isNotEmpty,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isUpcoming
                                    ? AppColors.romanticRoseLight.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                days == 0
                                    ? 'Today!'
                                    : isUpcoming
                                        ? '$days days'
                                        : 'Passed',
                                style: TextStyle(
                                  color: isUpcoming ? AppColors.romanticRoseLight : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                              onPressed: () => _confirmDeleteOccasion(context, occasion),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 24),

                // Gift Vault Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.giftVault,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.add),
                      onPressed: () => _showAddNoteDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedNoteCategory == 'all',
                        onSelected: (_) => setState(() => _selectedNoteCategory = 'all'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Gift Ideas 🎁'),
                        selected: _selectedNoteCategory == 'gift_idea',
                        onSelected: (_) => setState(() => _selectedNoteCategory = 'gift_idea'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('She Likes ✨'),
                        selected: _selectedNoteCategory == 'she_likes',
                        onSelected: (_) => setState(() => _selectedNoteCategory = 'she_likes'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Notes 📝'),
                        selected: _selectedNoteCategory == 'note',
                        onSelected: (_) => setState(() => _selectedNoteCategory = 'note'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                if (filteredNotes.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.noData,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...filteredNotes.map(
                    (note) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                          child: Icon(_getNoteIcon(note.category), color: AppColors.romanticRoseLight),
                        ),
                        title: Text(note.content),
                        subtitle: Text(
                          '${_getNoteCategoryLabel(note.category)} • ${AppDateUtils.formatDisplayDate(note.dateAdded)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                          onPressed: () => context.read<FianceeCubit>().deleteNote(note.id),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getOccasionIcon(String type) {
    switch (type) {
      case 'birthday':
        return Icons.cake;
      case 'anniversary':
        return Icons.favorite;
      case 'planned_date':
        return Icons.event;
      default:
        return Icons.celebration;
    }
  }

  IconData _getNoteIcon(String category) {
    switch (category) {
      case 'gift_idea':
        return Icons.card_giftcard;
      case 'she_likes':
        return Icons.star_outline;
      default:
        return Icons.notes;
    }
  }

  String _getNoteCategoryLabel(String category) {
    switch (category) {
      case 'gift_idea':
        return 'Gift Idea';
      case 'she_likes':
        return 'She Likes';
      default:
        return 'Note';
    }
  }

  void _confirmDeleteOccasion(BuildContext context, OccasionModel occasion) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('Delete occasion "${occasion.name}"? Scheduled notifications will also be cancelled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<FianceeCubit>().deleteOccasion(occasion.id);
              Navigator.of(context).pop();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddOccasionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final notesController = TextEditingController();
    String selectedType = 'birthday';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    bool repeatYearly = true;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.addOccasion),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.occasionName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Occasion Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'birthday', child: Text('Birthday 🎂')),
                    DropdownMenuItem(value: 'anniversary', child: Text('Anniversary 💍')),
                    DropdownMenuItem(value: 'planned_date', child: Text('Planned Date 🌹')),
                    DropdownMenuItem(value: 'custom', child: Text('Custom Celebration 🎉')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: AppColors.romanticRoseLight),
                  title: const Text('Date'),
                  subtitle: Text(AppDateUtils.formatDisplayDate(selectedDate)),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    child: const Text('Change'),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Repeat Yearly'),
                  subtitle: const Text('Auto-renews next year after passing'),
                  value: repeatYearly,
                  onChanged: (val) => setDialogState(() => repeatYearly = val),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: l10n.notes,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.romanticRoseLight,
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await HapticUtils.lightImpact();
                  if (dialogCtx.mounted) {
                    dialogCtx.read<FianceeCubit>().addOccasion(
                          OccasionModel(
                            name: name,
                            type: selectedType,
                            date: selectedDate,
                            repeatYearly: repeatYearly,
                            notes: notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                          ),
                        );
                    Navigator.of(dialogCtx).pop();
                  }
                }
              },
              child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentController = TextEditingController();
    String selectedCategory = 'gift_idea';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.add),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'gift_idea', child: Text('Gift Idea 🎁')),
                  DropdownMenuItem(value: 'she_likes', child: Text('She Likes ✨')),
                  DropdownMenuItem(value: 'note', child: Text('General Note 📝')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                autofocus: true,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.notes,
                  hintText: 'e.g. Favorite perfume, bracelet size, flowers she loves...',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.romanticRoseLight,
              ),
              onPressed: () async {
                final content = contentController.text.trim();
                if (content.isNotEmpty) {
                  await HapticUtils.lightImpact();
                  if (dialogCtx.mounted) {
                    dialogCtx.read<FianceeCubit>().addNote(
                          GiftNoteModel(
                            content: content,
                            category: selectedCategory,
                          ),
                        );
                    Navigator.of(dialogCtx).pop();
                  }
                }
              },
              child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

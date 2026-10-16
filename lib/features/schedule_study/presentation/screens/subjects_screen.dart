import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/subject_model.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  static const List<int> _palette = [
    0xFF2196F3, // Blue
    0xFF4CAF50, // Green
    0xFFFF9800, // Orange
    0xFFE91E63, // Pink
    0xFF9C27B0, // Purple
    0xFF00BCD4, // Cyan
    0xFFFF5722, // Deep Orange
    0xFF607D8B, // Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.academic,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.subjects),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.addSubject,
              onPressed: () => _showSubjectDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state.subjects.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noSubjectsYet,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(l10n.addSubject, style: const TextStyle(color: Colors.white)),
                        onPressed: () => _showSubjectDialog(context),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.subjects.length,
              itemBuilder: (context, index) {
                final subject = state.subjects[index];
                final subjectColor = Color(subject.colorValue);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: subjectColor.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: subjectColor,
                      child: Text(
                        subject.name.isNotEmpty ? subject.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      subject.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: subject.examDate != null
                        ? Text(
                            '${l10n.examDate}: ${AppDateUtils.formatDisplayDate(subject.examDate!)}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          tooltip: l10n.edit,
                          onPressed: () => _showSubjectDialog(context, subject: subject),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                          tooltip: l10n.delete,
                          onPressed: () => _confirmDelete(context, subject),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showSubjectDialog(BuildContext context, {Subject? subject}) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: subject?.name ?? '');
    int selectedColor = subject?.colorValue ?? _palette.first;
    DateTime? selectedExamDate = subject?.examDate;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(subject == null ? l10n.addSubject : l10n.editSubject),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.subjectName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.color,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _palette.map((colorVal) {
                    final isSelected = selectedColor == colorVal;
                    return InkWell(
                      onTap: () => setDialogState(() => selectedColor = colorVal),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(colorVal),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2.5)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event, color: AppColors.primary),
                  title: Text(l10n.examDate),
                  subtitle: Text(
                    selectedExamDate != null
                        ? AppDateUtils.formatDisplayDate(selectedExamDate!)
                        : l10n.noData,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedExamDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setDialogState(() => selectedExamDate = null),
                        ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedExamDate ?? DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedExamDate = picked);
                          }
                        },
                        child: Text(l10n.change),
                      ),
                    ],
                  ),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final cubit = dialogCtx.read<ScheduleCubit>();
                  if (subject == null) {
                    cubit.addSubject(Subject(
                      id: const Uuid().v4(),
                      name: name,
                      colorValue: selectedColor,
                      examDate: selectedExamDate,
                    ));
                  } else {
                    cubit.updateSubject(subject.copyWith(
                      name: name,
                      colorValue: selectedColor,
                      examDate: selectedExamDate,
                    ));
                  }
                  Navigator.of(dialogCtx).pop();
                }
              },
              child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Subject subject) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('${l10n.confirmDelete} (${subject.name})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              dialogCtx.read<ScheduleCubit>().deleteSubject(subject.id);
              Navigator.of(dialogCtx).pop();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

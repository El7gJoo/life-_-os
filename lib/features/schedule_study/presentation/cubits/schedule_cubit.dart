import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../gamification/domain/entities/ledger_entry.dart';
import '../../../settings_backup/data/repositories/settings_repository.dart';
import '../../../../services/notification_service.dart';
import '../../data/models/schedule_item_model.dart';
import '../../data/repositories/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _scheduleRepository;
  final GamificationRepository _gamificationRepository;
  final NotificationService _notificationService;
  final SettingsRepository _settingsRepository;

  ScheduleCubit(
    this._scheduleRepository,
    this._gamificationRepository,
    this._notificationService,
    this._settingsRepository,
  ) : super(ScheduleState(
          items: _scheduleRepository.getItems(),
          selectedDate: DateTime.now(),
        )) {
    calculateSleepTimes();
  }

  void refresh() {
    emit(state.copyWith(items: _scheduleRepository.getItems()));
    calculateSleepTimes();
  }

  Future<void> addItem(ScheduleItemModel item) async {
    await _scheduleRepository.addItem(item);
    // Schedule notification for item start
    await _notificationService.scheduleNotification(
      id: item.id.hashCode & 0x7FFFFFFF,
      title: 'Upcoming Task: ${item.title}',
      body: 'Scheduled for ${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}',
      scheduledDate: item.startTime,
    );
    refresh();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final item = state.items.firstWhereOrNull((i) => i.id == id);
    if (item == null) return;

    final updated = item.copyWith(isCompleted: !item.isCompleted);
    await _scheduleRepository.updateItem(updated);

    if (updated.isCompleted) {
      await _gamificationRepository.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.taskCompletionPoints,
        reason: 'Completed task: ${item.title}',
        sourceFeature: 'schedule',
        timestamp: DateTime.now(),
      ));
    } else {
      // Find and reverse ledger entry if exists
      final entries = _gamificationRepository.getLedgerEntries();
      final related = entries.firstWhereOrNull(
        (e) => e.sourceFeature == 'schedule' && e.reason.contains(item.title) && !e.isReversal,
      );
      if (related != null) {
        await _gamificationRepository.undoLedgerEntry(related.id);
      }
    }
    refresh();
  }

  Future<void> completePomodoro(String taskId) async {
    final item = state.items.firstWhereOrNull((i) => i.id == taskId);
    if (item != null && !item.isCompleted) {
      await _scheduleRepository.updateItem(item.copyWith(isCompleted: true));
    }

    await _gamificationRepository.addLedgerEntry(LedgerEntry(
      id: const Uuid().v4(),
      points: AppConstants.pomodoroPoints,
      reason: 'Completed Pomodoro session: ${item?.title ?? "Study"}',
      sourceFeature: 'schedule',
      timestamp: DateTime.now(),
    ));
    refresh();
  }

  Future<void> emergencyShiftOneHour() async {
    final now = DateTime.now();
    for (final item in state.items) {
      if (!item.isCompleted && item.startTime.isAfter(now)) {
        final shifted = item.copyWith(
          startTime: item.startTime.add(const Duration(hours: 1)),
          endTime: item.endTime.add(const Duration(hours: 1)),
          isShifted: true,
        );
        await _scheduleRepository.updateItem(shifted);
        // Reschedule notification
        await _notificationService.scheduleNotification(
          id: shifted.id.hashCode & 0x7FFFFFFF,
          title: 'Shifted Task: ${shifted.title}',
          body: 'Scheduled for ${shifted.startTime.hour.toString().padLeft(2, '0')}:${shifted.startTime.minute.toString().padLeft(2, '0')}',
          scheduledDate: shifted.startTime,
        );
      }
    }
    refresh();
  }

  void calculateSleepTimes() {
    final prepMinutes = _settingsRepository.getPrepTimeMinutes();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowItems = state.items.where((i) {
      return i.startTime.year == tomorrow.year &&
          i.startTime.month == tomorrow.month &&
          i.startTime.day == tomorrow.day;
    }).toList();

    if (tomorrowItems.isEmpty) {
      // Default to 8:00 AM wake up if no items
      final defaultWake = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8, 0);
      final defaultBed = defaultWake.subtract(const Duration(hours: 8));
      emit(state.copyWith(
        targetWakeUpTime: defaultWake,
        targetBedtime: defaultBed,
      ));
      return;
    }

    tomorrowItems.sort((a, b) => a.startTime.compareTo(b.startTime));
    final earliest = tomorrowItems.first.startTime;
    final wakeUp = earliest.subtract(Duration(minutes: prepMinutes));
    final bedtime = wakeUp.subtract(const Duration(hours: 8));

    emit(state.copyWith(
      targetWakeUpTime: wakeUp,
      targetBedtime: bedtime,
    ));
  }
}

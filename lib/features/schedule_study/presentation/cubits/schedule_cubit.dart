import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/models/ledger_entry_model.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
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

    if (!item.isCompleted) {
      final ledgerEntry = LedgerEntryModel(
        points: AppConstants.taskCompletionPoints,
        reason: 'Completed task: ${item.title}',
        sourceFeature: 'schedule',
        timestamp: DateTime.now(),
      );
      await _gamificationRepository.addLedgerEntry(ledgerEntry);
      await _scheduleRepository.markComplete(id, ledgerEntryId: ledgerEntry.id);
    } else {
      if (item.ledgerEntryId != null) {
        await _gamificationRepository.addReversal(
          item.ledgerEntryId!,
          'Undo: ${item.title}',
        );
      }
      await _scheduleRepository.undoComplete(id);
    }
    refresh();
  }

  Future<void> completePomodoro(String taskId) async {
    final item = state.items.firstWhereOrNull((i) => i.id == taskId);

    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.pomodoroPoints,
      reason: 'Completed Pomodoro session: ${item?.title ?? "Study"}',
      sourceFeature: 'schedule',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    if (item != null && !item.isCompleted) {
      await _scheduleRepository.markComplete(taskId, ledgerEntryId: ledgerEntry.id);
    }

    refresh();
  }

  Future<void> emergencyShiftOneHour() async {
    await _scheduleRepository.applyEmergencyShift(shiftMinutes: 60);
    final now = DateTime.now();
    for (final item in _scheduleRepository.getItems()) {
      if (!item.isCompleted && item.startTime.isAfter(now)) {
        await _notificationService.scheduleNotification(
          id: item.id.hashCode & 0x7FFFFFFF,
          title: 'Shifted Task: ${item.title}',
          body: 'Scheduled for ${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}',
          scheduledDate: item.startTime,
        );
      }
    }
    refresh();
  }

  void calculateSleepTimes() {
    final prepMinutes = _settingsRepository.getPrepTimeMinutes();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowItems = _scheduleRepository.getItemsForDate(tomorrow);

    if (tomorrowItems.isEmpty) {
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

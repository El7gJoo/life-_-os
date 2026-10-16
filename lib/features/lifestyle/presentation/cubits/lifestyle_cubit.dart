import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/models/ledger_entry_model.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../data/models/lifestyle_log_model.dart';
import '../../data/repositories/lifestyle_repository.dart';
import 'lifestyle_state.dart';

class LifestyleCubit extends Cubit<LifestyleState> {
  final LifestyleRepository _lifestyleRepository;
  final GamificationRepository _gamificationRepository;

  LifestyleCubit(
    this._lifestyleRepository,
    this._gamificationRepository,
  ) : super(LifestyleState(
          waterCups: _lifestyleRepository.getTodayWaterCups(),
          healthyMeals: _lifestyleRepository.getTodayMealCount(),
          gymSession: _lifestyleRepository.hasTodayWorkout(),
          sleepOnTime: false,
          wakeOnTime: false,
          allLogs: _lifestyleRepository.getLogs(),
        )) {
    refresh();
  }

  void refresh() {
    final now = DateTime.now();
    final todayLogs = _lifestyleRepository.getLogsForDate(now);
    final hasSleep = todayLogs.any((l) => l.type == 'sleep_start');
    final hasWake = todayLogs.any((l) => l.type == 'wake');

    emit(state.copyWith(
      waterCups: _lifestyleRepository.getTodayWaterCups(),
      healthyMeals: _lifestyleRepository.getTodayMealCount(),
      gymSession: _lifestyleRepository.hasTodayWorkout(),
      sleepOnTime: hasSleep,
      wakeOnTime: hasWake,
      allLogs: _lifestyleRepository.getLogs(),
    ));
  }

  Future<void> addWaterCup() async {
    await _lifestyleRepository.addLog(LifestyleLogModel(
      type: 'water',
      timestamp: DateTime.now(),
      value: 1,
    ));
    refresh();
  }

  Future<void> addHealthyMeal() async {
    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.healthyMealPoints,
      reason: 'Logged Healthy Meal',
      sourceFeature: 'lifestyle',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    await _lifestyleRepository.addLog(LifestyleLogModel(
      type: 'meal',
      timestamp: DateTime.now(),
      value: 1,
      ledgerEntryId: ledgerEntry.id,
    ));

    refresh();
  }

  Future<void> toggleGymSession() async {
    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.gymSessionPoints,
      reason: 'Gym Workout Session',
      sourceFeature: 'lifestyle',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    await _lifestyleRepository.addLog(LifestyleLogModel(
      type: 'workout',
      timestamp: DateTime.now(),
      ledgerEntryId: ledgerEntry.id,
    ));

    refresh();
  }

  Future<void> logSleepOnTime() async {
    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.sleepOnTimePoints,
      reason: 'Slept On Time',
      sourceFeature: 'lifestyle',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    await _lifestyleRepository.addLog(LifestyleLogModel(
      type: 'sleep_start',
      timestamp: DateTime.now(),
      ledgerEntryId: ledgerEntry.id,
    ));

    refresh();
  }

  Future<void> logWakeOnTime() async {
    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.wakeOnTimePoints,
      reason: 'Woke Up On Time',
      sourceFeature: 'lifestyle',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    await _lifestyleRepository.addLog(LifestyleLogModel(
      type: 'wake',
      timestamp: DateTime.now(),
      ledgerEntryId: ledgerEntry.id,
    ));

    refresh();
  }
}

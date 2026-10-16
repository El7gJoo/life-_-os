import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../gamification/domain/entities/ledger_entry.dart';
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
          todayLog: _lifestyleRepository.getLogForDate(
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
          ),
          allLogs: _lifestyleRepository.getAllLogs(),
        ));

  String get _todayDateKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  void refresh() {
    emit(state.copyWith(
      todayLog: _lifestyleRepository.getLogForDate(_todayDateKey),
      allLogs: _lifestyleRepository.getAllLogs(),
    ));
  }

  Future<void> addWaterCup() async {
    final updated = state.todayLog.copyWith(
      waterCups: state.todayLog.waterCups + 1,
    );
    await _lifestyleRepository.saveLog(updated);
    refresh();
  }

  Future<void> addHealthyMeal() async {
    final updated = state.todayLog.copyWith(
      healthyMeals: state.todayLog.healthyMeals + 1,
    );
    await _lifestyleRepository.saveLog(updated);

    await _gamificationRepository.addLedgerEntry(LedgerEntry(
      id: const Uuid().v4(),
      points: AppConstants.healthyMealPoints,
      reason: 'Logged Healthy Meal',
      sourceFeature: 'lifestyle',
      timestamp: DateTime.now(),
    ));

    refresh();
  }

  Future<void> toggleGymSession() async {
    final newStatus = !state.todayLog.gymSession;
    final updated = state.todayLog.copyWith(gymSession: newStatus);
    await _lifestyleRepository.saveLog(updated);

    if (newStatus) {
      await _gamificationRepository.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.gymSessionPoints,
        reason: 'Gym Workout Session',
        sourceFeature: 'lifestyle',
        timestamp: DateTime.now(),
      ));
    }

    refresh();
  }

  Future<void> logSleepOnTime() async {
    if (!state.todayLog.sleepOnTime) {
      final updated = state.todayLog.copyWith(sleepOnTime: true);
      await _lifestyleRepository.saveLog(updated);

      await _gamificationRepository.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.sleepOnTimePoints,
        reason: 'Slept On Time',
        sourceFeature: 'lifestyle',
        timestamp: DateTime.now(),
      ));

      refresh();
    }
  }

  Future<void> logWakeOnTime() async {
    if (!state.todayLog.wakeOnTime) {
      final updated = state.todayLog.copyWith(wakeOnTime: true);
      await _lifestyleRepository.saveLog(updated);

      await _gamificationRepository.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.wakeOnTimePoints,
        reason: 'Woke Up On Time',
        sourceFeature: 'lifestyle',
        timestamp: DateTime.now(),
      ));

      refresh();
    }
  }
}

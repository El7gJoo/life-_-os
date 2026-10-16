import 'package:equatable/equatable.dart';
import '../../data/models/lifestyle_log_model.dart';

class LifestyleState extends Equatable {
  final int waterCups;
  final int healthyMeals;
  final bool gymSession;
  final bool sleepOnTime;
  final bool wakeOnTime;
  final List<LifestyleLogModel> allLogs;

  const LifestyleState({
    required this.waterCups,
    required this.healthyMeals,
    required this.gymSession,
    required this.sleepOnTime,
    required this.wakeOnTime,
    required this.allLogs,
  });

  // Compatibility getter
  LifestyleState get todayLog => this;

  LifestyleState copyWith({
    int? waterCups,
    int? healthyMeals,
    bool? gymSession,
    bool? sleepOnTime,
    bool? wakeOnTime,
    List<LifestyleLogModel>? allLogs,
  }) {
    return LifestyleState(
      waterCups: waterCups ?? this.waterCups,
      healthyMeals: healthyMeals ?? this.healthyMeals,
      gymSession: gymSession ?? this.gymSession,
      sleepOnTime: sleepOnTime ?? this.sleepOnTime,
      wakeOnTime: wakeOnTime ?? this.wakeOnTime,
      allLogs: allLogs ?? this.allLogs,
    );
  }

  @override
  List<Object?> get props => [
        waterCups,
        healthyMeals,
        gymSession,
        sleepOnTime,
        wakeOnTime,
        allLogs,
      ];
}

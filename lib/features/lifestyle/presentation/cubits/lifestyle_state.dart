import 'package:equatable/equatable.dart';
import '../../data/models/lifestyle_log_model.dart';

class LifestyleState extends Equatable {
  final LifestyleLogModel todayLog;
  final List<LifestyleLogModel> allLogs;

  const LifestyleState({
    required this.todayLog,
    required this.allLogs,
  });

  LifestyleState copyWith({
    LifestyleLogModel? todayLog,
    List<LifestyleLogModel>? allLogs,
  }) {
    return LifestyleState(
      todayLog: todayLog ?? this.todayLog,
      allLogs: allLogs ?? this.allLogs,
    );
  }

  @override
  List<Object?> get props => [todayLog, allLogs];
}

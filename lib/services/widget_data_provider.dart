import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/schedule_study/data/repositories/schedule_repository.dart';

class WidgetDataProvider {
  int currentPoints = 0;
  int remainingTasksCount = 0;
  String? nextTaskTitle;
  DateTime? nextTaskTime;

  void update({
    required int points,
    required int remainingTasks,
    String? nextTask,
    DateTime? nextTime,
  }) {
    currentPoints = points;
    remainingTasksCount = remainingTasks;
    nextTaskTitle = nextTask;
    nextTaskTime = nextTime;
    // In future: call home_widget to update widget
  }

  void updateFromRepositories({
    required GamificationRepository gamificationRepo,
    required ScheduleRepository scheduleRepo,
  }) {
    final points = gamificationRepo.getCurrentPoints();
    final now = DateTime.now();
    final todayTasks = scheduleRepo.getItemsForDate(now);
    final remaining = todayTasks.where((t) => !t.isCompleted).toList();

    String? nextTitle;
    DateTime? nextTime;

    if (remaining.isNotEmpty) {
      remaining.sort((a, b) => a.startTime.compareTo(b.startTime));
      final next = remaining.first;
      nextTitle = next.title;
      nextTime = next.startTime;
    }

    update(
      points: points,
      remainingTasks: remaining.length,
      nextTask: nextTitle,
      nextTime: nextTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentPoints': currentPoints,
        'remainingTasksCount': remainingTasksCount,
        'nextTaskTitle': nextTaskTitle,
        'nextTaskTime': nextTaskTime?.toIso8601String(),
      };
}

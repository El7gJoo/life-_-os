import '../core/di/injection.dart';
import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/schedule_study/data/models/schedule_item_model.dart';
import '../features/schedule_study/data/repositories/schedule_repository.dart';

class WidgetDataProvider {
  int getPointsBalance() {
    return getIt<GamificationRepository>().getCurrentPoints();
  }

  int getRemainingTasksCount() {
    final now = DateTime.now();
    final items = getIt<ScheduleRepository>().getItems();
    return items.where((i) {
      return !i.isCompleted &&
          i.startTime.year == now.year &&
          i.startTime.month == now.month &&
          i.startTime.day == now.day;
    }).length;
  }

  ScheduleItemModel? getNextTask() {
    final now = DateTime.now();
    final items = getIt<ScheduleRepository>().getItems();
    final remaining = items.where((i) {
      return !i.isCompleted &&
          i.startTime.year == now.year &&
          i.startTime.month == now.month &&
          i.startTime.day == now.day &&
          i.startTime.isAfter(now);
    }).toList();

    if (remaining.isEmpty) return null;
    remaining.sort((a, b) => a.startTime.compareTo(b.startTime));
    return remaining.first;
  }

  Map<String, dynamic> getWidgetDataPayload() {
    final next = getNextTask();
    return {
      'pointsBalance': getPointsBalance(),
      'remainingTasksCount': getRemainingTasksCount(),
      'nextTaskTitle': next?.title ?? 'No more tasks today',
      'nextTaskTime': next != null
          ? '${next.startTime.hour.toString().padLeft(2, '0')}:${next.startTime.minute.toString().padLeft(2, '0')}'
          : '',
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

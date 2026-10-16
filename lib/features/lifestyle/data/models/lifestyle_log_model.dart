class LifestyleLogModel {
  final String date; // yyyy-MM-dd
  final int waterCups;
  final int healthyMeals;
  final bool gymSession;
  final bool sleepOnTime;
  final bool wakeOnTime;

  LifestyleLogModel({
    required this.date,
    this.waterCups = 0,
    this.healthyMeals = 0,
    this.gymSession = false,
    this.sleepOnTime = false,
    this.wakeOnTime = false,
  });

  LifestyleLogModel copyWith({
    String? date,
    int? waterCups,
    int? healthyMeals,
    bool? gymSession,
    bool? sleepOnTime,
    bool? wakeOnTime,
  }) {
    return LifestyleLogModel(
      date: date ?? this.date,
      waterCups: waterCups ?? this.waterCups,
      healthyMeals: healthyMeals ?? this.healthyMeals,
      gymSession: gymSession ?? this.gymSession,
      sleepOnTime: sleepOnTime ?? this.sleepOnTime,
      wakeOnTime: wakeOnTime ?? this.wakeOnTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'waterCups': waterCups,
        'healthyMeals': healthyMeals,
        'gymSession': gymSession,
        'sleepOnTime': sleepOnTime,
        'wakeOnTime': wakeOnTime,
      };

  factory LifestyleLogModel.fromJson(Map<dynamic, dynamic> json) =>
      LifestyleLogModel(
        date: json['date'] as String,
        waterCups: json['waterCups'] as int? ?? 0,
        healthyMeals: json['healthyMeals'] as int? ?? 0,
        gymSession: json['gymSession'] as bool? ?? false,
        sleepOnTime: json['sleepOnTime'] as bool? ?? false,
        wakeOnTime: json['wakeOnTime'] as bool? ?? false,
      );
}

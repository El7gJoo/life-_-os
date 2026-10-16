class ExpenseModel {
  final String id;
  final double amount;
  final String category;
  final String note;
  final DateTime timestamp;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.category,
    this.note = '',
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ExpenseModel.fromJson(Map<dynamic, dynamic> json) => ExpenseModel(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        category: json['category'] as String? ?? 'other',
        note: json['note'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

import 'package:uuid/uuid.dart';

class ExpenseModel {
  final String id;
  final double amount;
  final String category; // 'gas_fuel','university_food','coffee_drinks','transport','other'
  final String? note;
  final DateTime timestamp;
  final String currency;
  final String? ledgerEntryId; // for undo support

  ExpenseModel({
    String? id,
    required this.amount,
    required this.category,
    this.note,
    DateTime? timestamp,
    this.currency = 'EGP',
    this.ledgerEntryId,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
        'currency': currency,
        'ledgerEntryId': ledgerEntryId,
      };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        category: json['category'] as String,
        note: json['note'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        currency: json['currency'] as String? ?? 'EGP',
        ledgerEntryId: json['ledgerEntryId'] as String?,
      );

  ExpenseModel copyWith({
    String? id,
    double? amount,
    String? category,
    String? note,
    DateTime? timestamp,
    String? currency,
    String? ledgerEntryId,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        note: note ?? this.note,
        timestamp: timestamp ?? this.timestamp,
        currency: currency ?? this.currency,
        ledgerEntryId: ledgerEntryId ?? this.ledgerEntryId,
      );
}

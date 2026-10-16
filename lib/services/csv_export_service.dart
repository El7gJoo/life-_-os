import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../features/finance/data/models/expense_model.dart';

class CsvExportService {
  Future<void> exportExpensesToCsv({
    required List<ExpenseModel> expenses,
    required String currency,
    DateTime? month,
  }) async {
    final targetMonth = month ?? DateTime.now();
    final monthStr = DateFormat('yyyy-MM').format(targetMonth);

    final filtered = expenses.where((e) {
      return e.timestamp.year == targetMonth.year && e.timestamp.month == targetMonth.month;
    }).toList();

    filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // UTF-8 BOM
    final buffer = StringBuffer();
    buffer.write('\uFEFF');

    // Header
    buffer.writeln('Date,Time,Category,Note,Amount,Currency');

    // Rows
    final categoryTotals = <String, double>{};
    double grandTotal = 0;

    for (final exp in filtered) {
      final dateStr = DateFormat('yyyy-MM-dd').format(exp.timestamp);
      final timeStr = DateFormat('HH:mm').format(exp.timestamp);
      final safeNote = '"${(exp.note ?? '').replaceAll('"', '""')}"';
      buffer.writeln('$dateStr,$timeStr,${exp.category},$safeNote,${exp.amount.toStringAsFixed(2)},$currency');

      categoryTotals[exp.category] = (categoryTotals[exp.category] ?? 0) + exp.amount;
      grandTotal += exp.amount;
    }

    // Summary Section
    buffer.writeln();
    buffer.writeln('--- Category Summary ---,,,');
    buffer.writeln('Category,Total ($currency)');
    categoryTotals.forEach((cat, total) {
      buffer.writeln('$cat,${total.toStringAsFixed(2)}');
    });
    buffer.writeln('Grand Total,${grandTotal.toStringAsFixed(2)}');

    // Save and Share
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/expenses_$monthStr.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expenses for $monthStr',
    );
  }
}

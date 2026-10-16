import 'package:flutter/material.dart';

/// Helper to wrap numeric/symbolic/bidi fragments in Unicode LTR isolates (\u2066 ... \u2069)
/// so that numbers, arithmetic operators (+, -, /), currency and ratios render in the proper
/// direction in both Arabic (RTL) and English (LTR) modes without bidirectional reversals.
class RtlUtils {
  /// Wraps any string in Unicode Left-to-Right Isolate (LRI \u2066 ... PDI \u2069).
  static String ltr(Object? value) {
    if (value == null) return '';
    return '\u2066$value\u2069';
  }

  /// Formats points with a leading plus or minus: e.g. "+15" or "-50".
  static String formatPoints(int points) {
    final prefix = points > 0 ? '+' : '';
    return ltr('$prefix$points');
  }

  /// Formats points with badge label: e.g. "+15 pts" or "-50 pts".
  static String formatPointsBadge(int points, [String unit = 'pts']) {
    final prefix = points > 0 ? '+' : '';
    return ltr('$prefix$points $unit');
  }

  /// Formats currency with amount: e.g. "150.0 EGP" or "-50.0 EGP".
  static String formatCurrency(double amount, String currency, {int decimals = 1, bool isNegative = false}) {
    final sign = isNegative ? '-' : '';
    final formatted = amount.toStringAsFixed(decimals);
    return ltr('$sign$formatted $currency');
  }

  /// Formats ratio: e.g. "0 / 8" or "6 / 8".
  static String formatRatio(num current, num target) {
    return ltr('$current / $target');
  }

  /// Formats time in hours and minutes: e.g. "04:00"
  static String formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return ltr('$h:$m');
  }
}

/// Widget helper to enforce LTR rendering on any numeric or symbolic text child.
class LtrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const LtrText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
      ),
    );
  }
}

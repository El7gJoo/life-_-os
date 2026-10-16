import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticUtils {
  static Future<void> lightImpact() async {
    if (!kIsWeb) {
      await HapticFeedback.lightImpact();
    }
  }

  static Future<void> mediumImpact() async {
    if (!kIsWeb) {
      await HapticFeedback.mediumImpact();
    }
  }

  static Future<void> heavyImpact() async {
    if (!kIsWeb) {
      await HapticFeedback.heavyImpact();
    }
  }

  static Future<void> selectionClick() async {
    if (!kIsWeb) {
      await HapticFeedback.selectionClick();
    }
  }
}

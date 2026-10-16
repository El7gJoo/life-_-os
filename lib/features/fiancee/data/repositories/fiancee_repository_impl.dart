import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/gift_note_model.dart';
import '../models/occasion_model.dart';
import 'fiancee_repository.dart';

class FianceeRepositoryImpl extends FianceeRepository {
  final Box _box;

  FianceeRepositoryImpl(this._box);

  @override
  Future<void> addOccasion(OccasionModel occasion) async {
    await _box.put('occasion_${occasion.id}', occasion.toJson());
  }

  @override
  List<OccasionModel> getOccasions() {
    final list = <OccasionModel>[];
    for (final key in _box.keys) {
      if (key.toString().startsWith('occasion_')) {
        final value = _box.get(key);
        if (value is Map) {
          list.add(OccasionModel.fromJson(Map<String, dynamic>.from(value)));
        }
      }
    }
    list.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
    return list;
  }

  @override
  Future<void> updateOccasion(OccasionModel occasion) async {
    await _box.put('occasion_${occasion.id}', occasion.toJson());
  }

  @override
  Future<void> deleteOccasion(String id) async {
    await _box.delete('occasion_$id');
  }

  @override
  Future<void> addGiftNote(GiftNoteModel note) async {
    await _box.put('note_${note.id}', note.toJson());
  }

  @override
  List<GiftNoteModel> getGiftNotes() {
    final list = <GiftNoteModel>[];
    for (final key in _box.keys) {
      if (key.toString().startsWith('note_')) {
        final value = _box.get(key);
        if (value is Map) {
          list.add(GiftNoteModel.fromJson(Map<String, dynamic>.from(value)));
        }
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> updateGiftNote(GiftNoteModel note) async {
    await _box.put('note_${note.id}', note.toJson());
  }

  @override
  Future<void> deleteGiftNote(String id) async {
    await _box.delete('note_$id');
  }

  @override
  List<DateTime> getQualityTimeLogs() {
    final list = <DateTime>[];
    for (final key in _box.keys) {
      if (key.toString().startsWith('qt_')) {
        final value = _box.get(key);
        if (value is String) {
          final dt = DateTime.tryParse(value);
          if (dt != null) list.add(dt);
        }
      }
    }
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  @override
  Future<void> addQualityTimeLog(DateTime timestamp) async {
    await _box.put('qt_${timestamp.millisecondsSinceEpoch}', timestamp.toIso8601String());
  }

  @override
  String? getFianceeName() => _box.get(AppConstants.fianceeNameKey) as String?;

  @override
  Future<void> setFianceeName(String name) async {
    await _box.put(AppConstants.fianceeNameKey, name.trim());
  }

  @override
  Map<String, dynamic> exportAll() => {
        'fianceeName': getFianceeName(),
        'occasions': getOccasions().map((o) => o.toJson()).toList(),
        'notes': getGiftNotes().map((n) => n.toJson()).toList(),
        'qualityTimeLogs': getQualityTimeLogs().map((q) => q.toIso8601String()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    await _box.clear();
    if (data['fianceeName'] is String) {
      await setFianceeName(data['fianceeName'] as String);
    }
    if (data['occasions'] is List) {
      for (final item in data['occasions'] as List) {
        if (item is Map) {
          final occasion = OccasionModel.fromJson(Map<String, dynamic>.from(item));
          await addOccasion(occasion);
        }
      }
    }
    if (data['notes'] is List) {
      for (final item in data['notes'] as List) {
        if (item is Map) {
          final note = GiftNoteModel.fromJson(Map<String, dynamic>.from(item));
          await addGiftNote(note);
        }
      }
    }
    if (data['qualityTimeLogs'] is List) {
      for (final item in data['qualityTimeLogs'] as List) {
        if (item is String) {
          final dt = DateTime.tryParse(item);
          if (dt != null) await addQualityTimeLog(dt);
        }
      }
    }
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import '../models/gift_note_model.dart';
import '../models/occasion_model.dart';
import 'fiancee_repository.dart';

class FianceeRepositoryImpl implements FianceeRepository {
  final Box _box;

  FianceeRepositoryImpl(this._box);

  @override
  List<OccasionModel> getOccasions() {
    final list = <OccasionModel>[];
    for (final key in _box.keys) {
      if (key.toString().startsWith('occasion_')) {
        final data = _box.get(key);
        if (data is Map) {
          list.add(OccasionModel.fromJson(data));
        }
      }
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  @override
  Future<void> addOccasion(OccasionModel occasion) async {
    await _box.put('occasion_${occasion.id}', occasion.toJson());
  }

  @override
  Future<void> deleteOccasion(String id) async {
    await _box.delete('occasion_$id');
  }

  @override
  List<GiftNoteModel> getNotes() {
    final list = <GiftNoteModel>[];
    for (final key in _box.keys) {
      if (key.toString().startsWith('note_')) {
        final data = _box.get(key);
        if (data is Map) {
          list.add(GiftNoteModel.fromJson(data));
        }
      }
    }
    list.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return list;
  }

  @override
  Future<void> addNote(GiftNoteModel note) async {
    await _box.put('note_${note.id}', note.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete('note_$id');
  }

  @override
  Map<String, dynamic> exportAll() => Map<String, dynamic>.from(_box.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      ));

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    await _box.clear();
    await _box.putAll(data);
  }
}

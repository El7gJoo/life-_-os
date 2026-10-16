import '../models/gift_note_model.dart';
import '../models/occasion_model.dart';

abstract class FianceeRepository {
  Future<void> addOccasion(OccasionModel occasion);
  List<OccasionModel> getOccasions();
  Future<void> updateOccasion(OccasionModel occasion);
  Future<void> deleteOccasion(String id);

  Future<void> addGiftNote(GiftNoteModel note);
  List<GiftNoteModel> getGiftNotes();
  Future<void> updateGiftNote(GiftNoteModel note);
  Future<void> deleteGiftNote(String id);

  List<DateTime> getQualityTimeLogs();
  Future<void> addQualityTimeLog(DateTime timestamp);

  // Backward compatibility convenience methods
  List<GiftNoteModel> getNotes() => getGiftNotes();
  Future<void> addNote(GiftNoteModel note) => addGiftNote(note);
  Future<void> deleteNote(String id) => deleteGiftNote(id);

  String? getFianceeName();
  Future<void> setFianceeName(String name);

  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}

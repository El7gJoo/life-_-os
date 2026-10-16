import '../models/gift_note_model.dart';
import '../models/occasion_model.dart';

abstract class FianceeRepository {
  List<OccasionModel> getOccasions();
  Future<void> addOccasion(OccasionModel occasion);
  Future<void> deleteOccasion(String id);
  List<GiftNoteModel> getNotes();
  Future<void> addNote(GiftNoteModel note);
  Future<void> deleteNote(String id);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/models/ledger_entry_model.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../../services/notification_service.dart';
import '../../data/models/gift_note_model.dart';
import '../../data/models/occasion_model.dart';
import '../../data/repositories/fiancee_repository.dart';
import 'fiancee_state.dart';

class FianceeCubit extends Cubit<FianceeState> {
  final FianceeRepository _fianceeRepository;
  final GamificationRepository _gamificationRepository;
  final NotificationService _notificationService;

  FianceeCubit(
    this._fianceeRepository,
    this._gamificationRepository,
    this._notificationService,
  ) : super(FianceeState(
          occasions: _fianceeRepository.getOccasions(),
          notes: _fianceeRepository.getGiftNotes(),
          isAuthenticated: false,
          isQualityTimeCompletedToday: false,
          fianceeName: _fianceeRepository.getFianceeName(),
        ));

  void refresh() {
    emit(state.copyWith(
      occasions: _fianceeRepository.getOccasions(),
      notes: _fianceeRepository.getGiftNotes(),
      fianceeName: () => _fianceeRepository.getFianceeName(),
    ));
  }

  Future<void> updateFianceeName(String name) async {
    await _fianceeRepository.setFianceeName(name);
    emit(state.copyWith(fianceeName: () => name.trim()));
  }

  void setAuthenticated(bool authenticated) {
    emit(state.copyWith(isAuthenticated: authenticated));
  }

  Future<void> addOccasion(OccasionModel occasion) async {
    await _fianceeRepository.addOccasion(occasion);
    // Schedule 3-stage occasion alerts
    await _notificationService.scheduleOccasionAlerts(
      occasionId: occasion.id,
      occasionName: occasion.name,
      occasionDate: occasion.nextOccurrence,
    );
    refresh();
  }

  Future<void> deleteOccasion(String id) async {
    await _notificationService.cancelOccasionAlerts(id);
    await _fianceeRepository.deleteOccasion(id);
    refresh();
  }

  Future<void> addNote(GiftNoteModel note) async {
    await _fianceeRepository.addGiftNote(note);
    refresh();
  }

  Future<void> deleteNote(String id) async {
    await _fianceeRepository.deleteGiftNote(id);
    refresh();
  }

  Future<void> completeQualityTime() async {
    final now = DateTime.now();
    await _fianceeRepository.addQualityTimeLog(now);
    await _gamificationRepository.addLedgerEntry(LedgerEntryModel(
      points: AppConstants.qualityTimePoints,
      reason: 'Fiancée Quality Time',
      sourceFeature: 'fiancee',
      timestamp: now,
    ));
    emit(state.copyWith(isQualityTimeCompletedToday: true));
  }
}

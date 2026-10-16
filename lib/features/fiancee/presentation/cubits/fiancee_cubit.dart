import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../gamification/domain/entities/ledger_entry.dart';
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
          notes: _fianceeRepository.getNotes(),
          isAuthenticated: false,
          isQualityTimeCompletedToday: false,
        ));

  void refresh() {
    emit(state.copyWith(
      occasions: _fianceeRepository.getOccasions(),
      notes: _fianceeRepository.getNotes(),
    ));
  }

  void setAuthenticated(bool authenticated) {
    emit(state.copyWith(isAuthenticated: authenticated));
  }

  Future<void> addOccasion(OccasionModel occasion) async {
    await _fianceeRepository.addOccasion(occasion);
    // Schedule 3-stage notifications
    await _notificationService.schedule3StageOccasion(
      baseId: occasion.id.hashCode & 0x3FFFFFFF,
      name: occasion.title,
      occasionDate: occasion.date,
    );
    refresh();
  }

  Future<void> deleteOccasion(String id) async {
    await _fianceeRepository.deleteOccasion(id);
    refresh();
  }

  Future<void> addNote(GiftNoteModel note) async {
    await _fianceeRepository.addNote(note);
    refresh();
  }

  Future<void> deleteNote(String id) async {
    await _fianceeRepository.deleteNote(id);
    refresh();
  }

  Future<void> completeQualityTime() async {
    await _gamificationRepository.addLedgerEntry(LedgerEntry(
      id: const Uuid().v4(),
      points: AppConstants.qualityTimePoints,
      reason: 'Fiancée Quality Time',
      sourceFeature: 'fiancee',
      timestamp: DateTime.now(),
    ));
    emit(state.copyWith(isQualityTimeCompletedToday: true));
  }
}

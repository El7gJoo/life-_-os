import 'package:equatable/equatable.dart';
import '../../data/models/gift_note_model.dart';
import '../../data/models/occasion_model.dart';

class FianceeState extends Equatable {
  final List<OccasionModel> occasions;
  final List<GiftNoteModel> notes;
  final bool isAuthenticated;
  final bool isQualityTimeCompletedToday;

  const FianceeState({
    required this.occasions,
    required this.notes,
    required this.isAuthenticated,
    required this.isQualityTimeCompletedToday,
  });

  FianceeState copyWith({
    List<OccasionModel>? occasions,
    List<GiftNoteModel>? notes,
    bool? isAuthenticated,
    bool? isQualityTimeCompletedToday,
  }) {
    return FianceeState(
      occasions: occasions ?? this.occasions,
      notes: notes ?? this.notes,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isQualityTimeCompletedToday:
          isQualityTimeCompletedToday ?? this.isQualityTimeCompletedToday,
    );
  }

  @override
  List<Object?> get props => [
        occasions,
        notes,
        isAuthenticated,
        isQualityTimeCompletedToday,
      ];
}

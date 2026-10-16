import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/fiancee/data/models/gift_note_model.dart';
import 'package:life_os/features/fiancee/data/models/occasion_model.dart';
import 'package:life_os/features/fiancee/data/repositories/fiancee_repository.dart';
import 'package:life_os/features/fiancee/presentation/cubits/fiancee_cubit.dart';
import 'package:life_os/features/gamification/data/repositories/gamification_repository.dart';
import 'package:life_os/services/notification_service.dart';

class MockFianceeRepository extends Fake implements FianceeRepository {
  String? _fianceeName;
  final List<OccasionModel> _occasions = [];
  final List<GiftNoteModel> _notes = [];

  @override
  String? getFianceeName() => _fianceeName;

  @override
  Future<void> setFianceeName(String name) async {
    _fianceeName = name.trim();
  }

  @override
  List<OccasionModel> getOccasions() => _occasions;

  @override
  List<GiftNoteModel> getGiftNotes() => _notes;

  @override
  Map<String, dynamic> exportAll() => {
        'fianceeName': getFianceeName(),
        'occasions': _occasions.map((o) => o.toJson()).toList(),
        'notes': _notes.map((n) => n.toJson()).toList(),
        'qualityTimeLogs': <String>[],
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['fianceeName'] is String) {
      await setFianceeName(data['fianceeName'] as String);
    }
  }
}

class MockGamificationRepository extends Fake implements GamificationRepository {}

class MockNotificationService extends Fake implements NotificationService {}

void main() {
  group('Dynamic Fiancée Name Tests', () {
    late MockFianceeRepository fianceeRepo;
    late MockGamificationRepository gamificationRepo;
    late MockNotificationService notificationService;

    setUp(() {
      fianceeRepo = MockFianceeRepository();
      gamificationRepo = MockGamificationRepository();
      notificationService = MockNotificationService();
    });

    test('Initial state loads fiancée name from repository', () {
      final cubit = FianceeCubit(fianceeRepo, gamificationRepo, notificationService);
      expect(cubit.state.fianceeName, isNull);
    });

    test('Initial state loads existing fiancée name if previously saved', () async {
      await fianceeRepo.setFianceeName('Sarah');
      final cubit = FianceeCubit(fianceeRepo, gamificationRepo, notificationService);
      expect(cubit.state.fianceeName, equals('Sarah'));
    });

    test('updateFianceeName updates repo and emits updated state with trimmed name', () async {
      final cubit = FianceeCubit(fianceeRepo, gamificationRepo, notificationService);
      await cubit.updateFianceeName('  Mariam  ');

      expect(cubit.state.fianceeName, equals('Mariam'));
      expect(fianceeRepo.getFianceeName(), equals('Mariam'));
    });

    test('exportAll and importAll preserve custom fiancée name in backup', () async {
      await fianceeRepo.setFianceeName('Nour');
      final exported = fianceeRepo.exportAll();
      expect(exported['fianceeName'], equals('Nour'));

      final newRepo = MockFianceeRepository();
      expect(newRepo.getFianceeName(), isNull);

      await newRepo.importAll(exported);
      expect(newRepo.getFianceeName(), equals('Nour'));
    });
  });
}

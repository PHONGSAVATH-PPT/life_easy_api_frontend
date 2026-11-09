import 'models.dart';

// An abstract class that defines the interface for a life repository. --- IGNORE ---

abstract interface class LifeRepository {
  Future<LifeSnapshot> load();

  Future<LifeSnapshot> save(LifeEntry entry);

  Future<LifeSnapshot> remove(String id);

  Future<LifeSnapshot> toggleTask(String id);

  Future<LifeSnapshot> payBill(String id);
}

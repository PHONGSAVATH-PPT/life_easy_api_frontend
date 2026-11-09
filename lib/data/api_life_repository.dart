import 'package:dio/dio.dart';

import '../domain/life_repository.dart';
import '../domain/models.dart';

class ApiLifeRepository implements LifeRepository {
  ApiLifeRepository(this.client);

  final Dio client;

  Future<LifeSnapshot> _read(Future<Response<dynamic>> request) async {
    final response = await request;

    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;

    return LifeSnapshot(
      entries: (data['entries'] as List)
          .map((item) => LifeEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
      members: (data['members'] as List)
          .map((item) => Member.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<LifeSnapshot> load() {
    return _read(client.get('/workspace'));
  }

  @override
  Future<LifeSnapshot> save(LifeEntry entry) {
    return _read(
      client.put(
        '/entries/${Uri.encodeComponent(entry.id)}',
        data: entry.toJson(),
      ),
    );
  }

  @override
  Future<LifeSnapshot> remove(String id) {
    return _read(client.delete('/entries/${Uri.encodeComponent(id)}'));
  }

  @override
  Future<LifeSnapshot> toggleTask(String id) {
    return _read(client.post('/entries/${Uri.encodeComponent(id)}/toggle'));
  }

  @override
  Future<LifeSnapshot> payBill(String id) {
    return _read(
      client.post(
        '/bills/${Uri.encodeComponent(id)}/pay',
        options: Options(headers: {'Idempotency-Key': 'pay-$id'}),
      ),
    );
  }
}

import 'package:coach_app/core/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Required for flutter_secure_storage platform channel access in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiClient', () {
    test('instantiates with baseUrl', () {
      final client = ApiClient(baseUrl: 'http://localhost:8080/api/v1');
      expect(client, isNotNull);
    });

    test('hasToken returns false when no token stored', () async {
      final client = ApiClient(baseUrl: 'http://localhost:8080/api/v1');
      expect(await client.hasToken(), isFalse);
    });
  });
}

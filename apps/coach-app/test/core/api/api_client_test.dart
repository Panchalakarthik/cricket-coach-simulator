import 'package:coach_app/core/api/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('ApiClient', () {
    test('instantiates with baseUrl', () {
      final client = ApiClient(
        baseUrl: 'http://localhost:8080/api/v1',
        storage: _MockStorage(),
      );
      expect(client, isNotNull);
    });

    test('hasToken returns false when no token stored', () async {
      final storage = _MockStorage();
      when(() => storage.read(key: _kTokenKey)).thenAnswer((_) async => null);

      final client = ApiClient(
        baseUrl: 'http://localhost:8080/api/v1',
        storage: storage,
      );
      expect(await client.hasToken(), isFalse);
    });
  });
}

const _kTokenKey = 'auth_token';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageTodosApi', () {
    late SharedPreferences plugin;

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(null);
    });

    test('can be instantiated', () {
      expect(LocalStorageTodosApi(plugin: plugin), isNotNull);
    });
  });
}

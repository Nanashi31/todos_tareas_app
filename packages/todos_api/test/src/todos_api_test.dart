import 'package:test/test.dart';
import 'package:todos_api/todos_api.dart';

class TestTodosApi extends TodosApi {
  @override
  Future<int> clearCompleted() async {
    return 0;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    return 0;
  }

  @override
  Future<void> deleteTodo(String id) async {}

  @override
  Stream<List<Todo>> getTodos() {
    return Stream.value([]);
  }

  @override
  Future<void> saveTodo(Todo todo) async {}

  @override
  Future<void> close() async {}
}

void main() {
  group('TodosApi', () {
    test('can be instantiated', () {
      expect(TestTodosApi(), isNotNull);
    });
  });
}

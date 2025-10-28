import 'package:flutter_test/flutter_test.dart';
import 'package:javerage_todos/app/view/app.dart';
import 'package:javerage_todos/features/home/view/home_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  group('App', () {
    late TodosRepository todosRepository;

    setUp(() {
      todosRepository = MockTodosRepository();
      when(() => todosRepository.getTodos()).thenAnswer((_) => Stream.value([]));
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(createTodosRepository: () => todosRepository),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:taskapp/main.dart';

void main() {
  testWidgets('ClayTasksApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ClayTasksApp());
    await tester.pumpAndSettle();

    expect(find.text('Clay Tasks'), findsWidgets);
    expect(find.text('Tasks Hub'), findsOneWidget);
  });
}

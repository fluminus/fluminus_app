import 'package:flutter_test/flutter_test.dart';
import 'package:randomword_app/main.dart';

void main() {
  testWidgets('is working!', (tester) async {
    await tester.pumpWidget(new App());
    expect(find.text("Random Word Generator"), findsOneWidget);
  });
}
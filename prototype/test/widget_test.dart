import 'package:flutter_test/flutter_test.dart';
import 'package:icetrack/main.dart';

void main() {
  testWidgets('IceTrack UI-01 Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const IceTrackApp());

    expect(find.text('UI-01: Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
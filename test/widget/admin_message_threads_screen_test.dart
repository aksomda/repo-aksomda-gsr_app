import 'package:flutter_test/flutter_test.dart';
import 'package:gsr_app/features/chat/presentation/screens/admin_message_threads_screen.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets(
    'affiche le bouton "Nouveau message" et le message de liste vide',
    (tester) async {
      await tester.pumpWidget(
        buildFakeApp(
          isAdmin: true,
          home: frApp(const AdminMessageThreadsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nouveau message'), findsOneWidget);
      expect(find.textContaining("Aucun message d'agent"), findsOneWidget);
    },
  );
}

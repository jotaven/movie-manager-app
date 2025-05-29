import 'package:flutter_test/flutter_test.dart';
import 'package:movie_manager/main.dart';

void main() {
  testWidgets('Open modal on icon click', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica se o botão de informação está presente
    final infoButton = find.byTooltip('Sobre a equipe');
    expect(infoButton, findsOneWidget);

    // Toca no botão de informação
        await tester.tap(infoButton);
        await tester.pumpAndSettle();

    // Verifica se o modal e os textos esperados apareceram
        expect(find.text('Equipe:'), findsOneWidget);
        expect(find.text('Gustavo Targino'), findsOneWidget);
        expect(find.text('João Pedro Soares'), findsOneWidget);
        expect(find.text('João Victor Nunes'), findsOneWidget);
        expect(find.text('Luiz Filipe'), findsOneWidget);

    // Clica no botão "Ok" para fechar o modal
        final okButton = find.text('Ok');
        expect(okButton, findsOneWidget);

        await tester.tap(okButton);
        await tester.pumpAndSettle();

    // Verifica se o modal foi fechado (textos somem)
        expect(find.text('Equipe:'), findsNothing);
  });


}

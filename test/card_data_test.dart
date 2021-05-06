import 'package:cardgameset/data/card_data.dart';
import 'package:test/test.dart';

void main() {
  group('Card data', () {
    test('Building cards should result in 3**4 combinations', () {
      var cards = allCards;
      expect(cards.length, equals(81));
    });
    test('Building cards should have no duplicates', () {
      var cards = allCards;
      expect(cards.toSet().length, equals(81));
    });
  });
}

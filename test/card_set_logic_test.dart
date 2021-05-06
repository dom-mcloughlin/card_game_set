import 'package:cardgameset/data/card_data.dart';
import 'package:cardgameset/services/card_set_logic.dart';
import 'package:test/test.dart';

void main() {
  group('Card set matching', () {
    test('1111 2222 3333 is a match', () {
      var cards = allCards;
      var currentSet = <CardData>[];
      for (var card in cards) {
        if ((card.shape == ShapeShape.rrect &&
                card.color == ShapeColor.pink &&
                card.texture == ShapeTexture.solid &&
                card.number == ShapeNumber.one) ||
            (card.shape == ShapeShape.oval &&
                card.color == ShapeColor.purple &&
                card.texture == ShapeTexture.empty &&
                card.number == ShapeNumber.two) ||
            (card.shape == ShapeShape.diamond &&
                card.color == ShapeColor.red &&
                card.texture == ShapeTexture.stripey &&
                card.number == ShapeNumber.three)) {
          currentSet.add(card);
        }
      }
      expect(currentSet.length, equals(3));
      expect(isMatchingSet(currentSet), isTrue);
    });
  });

  group('Card set not matching', () {
    test('1111 2222 1333 is not a match', () {
      var cards = allCards;
      var currentSet = <CardData>[];
      for (var card in cards) {
        if ((card.shape == ShapeShape.rrect &&
                card.color == ShapeColor.pink &&
                card.texture == ShapeTexture.solid &&
                card.number == ShapeNumber.one) ||
            (card.shape == ShapeShape.oval &&
                card.color == ShapeColor.purple &&
                card.texture == ShapeTexture.empty &&
                card.number == ShapeNumber.two) ||
            (card.shape == ShapeShape.rrect &&
                card.color == ShapeColor.red &&
                card.texture == ShapeTexture.stripey &&
                card.number == ShapeNumber.three)) {
          currentSet.add(card);
        }
      }
      expect(currentSet.length, equals(3));
      expect(isMatchingSet(currentSet), isFalse);
    });
  });

}

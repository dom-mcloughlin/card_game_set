import 'package:flutter/material.dart';

List<int> indices = [1, 2, 3];
int numberOfVariables = 4;
List<int> invalidSums = [1, 2, 4, 5];

final allCards = _buildCards();
final List<int> allCardIndices = [
  for (int ii = 0; ii < allCards.length; ii++) ii
];

List<CardData> _buildCards() => [
      // Create all combinations (3**4) of the four indices.
      // For example, a card combination of [1, 2, 1, 3] would correspond to
      // Shape 1, Colour 2, Texture 1, Number 3.
      for (var a in ShapeShape.values)
        for (var b in ShapeColor.values)
          for (var c in ShapeTexture.values)
            for (var d in ShapeNumber.values) CardData(a, b, c, d)
    ];

enum ShapeShape {
  rrect,
  oval,
  diamond,
}

enum ShapeColor {
  pink,
  purple,
  red,
}

enum ShapeTexture {
  solid,
  empty,
  stripey,
}

enum ShapeNumber {
  one,
  two,
  three,
}

class CardData {
  final ShapeShape shape;
  final ShapeColor color;
  final ShapeTexture texture;
  final ShapeNumber number;

  const CardData(
    this.shape,
    this.color,
    this.texture,
    this.number,
  );

  Color cardColor() {
    final pinkColor = Color(0xffffa8cb);

    final purpleColor = Color(0xff784283);

    final redColor = Color(0xffe5000c);

    switch (color) {
      case ShapeColor.pink:
        return pinkColor;
      case ShapeColor.purple:
        return purpleColor;
      case ShapeColor.red:
        return redColor;
    }
  }
}

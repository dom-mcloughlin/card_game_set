List<int> indices = [1, 2, 3];
int numberOfVariables = 4;
List<int> invalidSums = [1, 2, 4, 5];

final allCardCombinations = buildCardCombinations();
final List<int> allCardIndices = [
  for (int ii = 0; ii <= allCardCombinations.length; ii++) ii
];

List<List<int>> buildCardCombinations() => [
      // Create all combinations (3**4) of the four indices.
      // For example, a card combination of [1, 2, 1, 3] would correspond to
      // Shape 1, Colour 2, Texture 1, Number 3.
      for (int d in indices)
        for (int c in indices)
          for (int b in indices)
            for (int a in indices) [a, b, c, d]
    ];

enum allShapeShapes {
  rrect,
  oval,
  diamond,
}

enum allShapeColors {
  pink,
  purple,
  red,
}

enum allShapeTextures {
  solid,
  empty,
  stripey,
}

enum allShapeNumbers {
  one,
  two,
  three,
}

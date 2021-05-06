import 'package:cardgameset/data/card_data.dart';

bool isMatchingSet(List<CardData> cards) {
  if (!_isSameOrDifferent(cards.map((e) => e.shape).toList())) return false;
  if (!_isSameOrDifferent(cards.map((e) => e.color).toList())) return false;
  if (!_isSameOrDifferent(cards.map((e) => e.texture).toList())) return false;
  if (!_isSameOrDifferent(cards.map((e) => e.number).toList())) return false;
  return true;
}

bool _allSame(List<Object> objects) {
  assert(objects.length == 3);
  return objects.every((element) => element == objects.first);
}

bool _allDifferent(List<Object> objects) {
  assert(objects.length == 3);
  return objects.length == objects.toSet().length;
}

bool _isSameOrDifferent(List<Object> objects) =>
    _allSame(objects) | _allDifferent(objects);
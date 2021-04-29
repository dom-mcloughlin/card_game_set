import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Find the sets'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final indices = <int>[1, 2, 3];
  var cards = <PlayingCard>{};

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[...buildCardRows()]),
      ),
    );
  }

  buildCardRows() => [
        for (int ii = 0; ii < 4; ii++)
          Expanded(child: Row(children: nextCards(3).toList()))
      ];

  buildCardCombinations() => [
        // Create all combinations (3**4) of the four indices.
        // For example, a card combination of [1, 2, 1, 3] would correspond to
        // Shape 1, Colour 2, Texture 1, Number 3.
        for (int d in this.indices)
          for (int c in this.indices)
            for (int b in this.indices)
              for (int a in this.indices) [a, b, c, d]
      ];

  List<PlayingCard> buildCards() =>
      [for (var name in buildCardCombinations()) PlayingCard(name)];

  Iterable<PlayingCard> nextCards(int n) sync* {
    // Build all 3**4 card combinations once only and shuffle.
    // Take the first n, add to end of list, and yield them.
    // Maybe this should be a Queue instead since taking first element.
    int ii = 0;
    final List<PlayingCard> cards = buildCards();
    cards.shuffle();
    while (ii < n) {
      PlayingCard card = cards.elementAt(ii);
      this.cards.add(card);
      yield card;
      ii++;
    }
  }
}

class PlayingCard extends StatefulWidget {
  final List name;

  PlayingCard(this.name);

  @override
  _PlayingCardState createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  bool selectedCard = false;

  final Color pinkColor = Color(0xffffa8cb);

  final Color purpleColor = Color(0xff784283);

  final Color redColor = Color(0xffe5000c);

  final Color blackColor = Color(0xff000000);

  final Color goldColor = Color(0xffffbf00);

  int myShapeIndex() {
    return widget.name.elementAt(4) - 1;
  }

  int myColorIndex() {
    return widget.name.elementAt(1) - 1;
  }

  int myTextureIndex() {
    return widget.name.elementAt(2) - 1;
  }

  int myNumberIndex() {
    return widget.name.elementAt(3);
  }

  Color myColor() {
    if (myColorIndex() == 0) {
      return pinkColor;
    }
    if (myColorIndex() == 1) {
      return purpleColor;
    }
    if (myColorIndex() == 2) {
      return redColor;
    }
    return blackColor;
  }

  void toggleSelected() {
    setState(() {
      this.selectedCard = !this.selectedCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: selectedCard
            ? new RoundedRectangleBorder(
                side: new BorderSide(color: goldColor, width: 5.0),
                borderRadius: BorderRadius.circular(4.0))
            : new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.white, width: 0),
                borderRadius: BorderRadius.circular(4.0)),
        color: myColor(),
        child: new InkWell(
          onTap: () {
            this.toggleSelected();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int ii = 0; ii < this.myNumberIndex(); ii++)
                Text(
                  this.widget.name.map((i) => i.toString()).join(","),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

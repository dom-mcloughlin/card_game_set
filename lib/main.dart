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
  int _counter = 0;
  var names = <List>[
    [1, 2, 3, 4],
    [1, 2, 3, 3],
    [1, 2, 2, 1]
  ];
  final indices = <int>[1, 2, 3, 4];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        child: Column(children: [...buildCardRows()]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
        for (var d in this.indices)
          for (var c in this.indices)
            for (var b in this.indices)
              for (var a in this.indices) [a, b, c, d]
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
      yield card;
      ii++;
    }
  }
}

class PlayingCard extends StatelessWidget {
  final List name;

  PlayingCard(this.name);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Center(
          child: Column(
            children: [
              Text(this.name.map((i) => i.toString()).join(",")),
            ],
          ),
        ),
      ),
    );
  }
}

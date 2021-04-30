import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  final Color blueColor = Color(0xff82a5df);

  int myShapeIndex() {
    return widget.name.elementAt(0) - 1;
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

  myIconShape() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      child: CustomPaint(
          painter: ShapePainter(
        this.myShapeIndex(),
        this.myColor(),
        this.myTextureIndex(),
        this.myNumberIndex(),
        queryData.size.height * 0.03,
      )),
    );
  }

  void toggleSelected() {
    setState(() {
      this.selectedCard = !this.selectedCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Card(
          shape: selectedCard
              ? new RoundedRectangleBorder(
                  side: new BorderSide(color: goldColor, width: 5.0),
                  borderRadius: BorderRadius.circular(4.0))
              : new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 0),
                  borderRadius: BorderRadius.circular(4.0)),
          color: blueColor,
          child: new InkWell(
            onTap: () {
              this.toggleSelected();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myIconShape(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final int shapeShape;
  final Color shapeColor;
  final int shapeTexture;
  final int shapeNumber;
  final double shapeSize;

  ShapePainter(this.shapeShape, this.shapeColor, this.shapeTexture,
      this.shapeNumber, this.shapeSize);

  @override
  void paint(Canvas canvas, Size size) {
    // final double centerX = size.width / 2;
    final double centerX = size.width/2;

    Paint paint = Paint()
      ..color = this.shapeColor
      ..strokeWidth = 8.0;

    switch (this.shapeTexture) {
      case 0:
        paint.style = PaintingStyle.fill;
        break;
      case 1:
        paint.style = PaintingStyle.stroke;
        break;
      case 2:
        paint.style = PaintingStyle.fill;
        paint.shader = LinearGradient(
          begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          stops: [0.0, 0.5, 0.5, 1],
          colors: [this.shapeColor, Colors.white, this.shapeColor, Colors.white],
          tileMode: TileMode.repeated,
        ).createShader(Rect.fromCircle(
            center: Offset(size.width / 2, 0), radius: this.shapeSize / 2));
        break;
    }

    Path path = Path();
    var myRectangles = <Rect>[];

    switch (this.shapeNumber) {
      case 1:
        print(size.width);
        print(size.height);
        print(this.shapeSize);
        Rect myRect = Offset(centerX - this.shapeSize, 0) &
            Size(3 * this.shapeSize, this.shapeSize);

        myRectangles.add(myRect);
        break;
      case 2:
        Rect myRect1 = Offset(centerX - this.shapeSize, -this.shapeSize) &
            Size(3 * this.shapeSize, this.shapeSize);
        myRectangles.add(myRect1);

        Rect myRect2 = Offset(centerX - this.shapeSize, this.shapeSize) &
            Size(3 * this.shapeSize, this.shapeSize);
        myRectangles.add(myRect2);
        break;
      case 3:
        Rect myRect1 = Offset(centerX - this.shapeSize, -2 * this.shapeSize) &
            Size(3 * this.shapeSize, this.shapeSize);
        myRectangles.add(myRect1);

        Rect myRect2 = Offset(centerX - this.shapeSize, 0) &
            Size(3 * this.shapeSize, this.shapeSize);
        myRectangles.add(myRect2);

        Rect myRect3 = Offset(centerX - this.shapeSize, 2 * this.shapeSize) &
            Size(3 * this.shapeSize, this.shapeSize);

        myRectangles.add(myRect3);
        break;
    }

    for (Rect myRect in myRectangles) {
      switch (this.shapeShape) {
        case 0:
          path.addRRect(RRect.fromRectAndRadius(
            myRect,
            Radius.circular(15))
            );
          break;
        case 1:
          path.addOval(myRect);
          break;
        case 2:
          path.moveTo(centerX - this.shapeSize, 0);
          path.lineTo(centerX, this.shapeSize);
          path.lineTo(centerX + this.shapeSize, 0);
          path.lineTo(centerX, -this.shapeSize);
          path.lineTo(centerX - this.shapeSize, 0);
          path.close();
          break;
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

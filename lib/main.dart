import 'package:cardgameset/data/card_data.dart';
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
  final int nRows = 4;
  final int nColumns = 3;
  List deckCardIndices = allCardIndices;
  List tableCardIndices = <int>[];
  Set markedCardIndices = <int>{};

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

  void setCardMarked(PlayingCard card) {
    setState(() {
      if (markedCardIndices.contains(card.cardIndex)) {
        markedCardIndices.remove(card.cardIndex);
      } else {
        markedCardIndices.add(card.cardIndex);
      }
      checkSet();
    });
  }

  void checkSet() {
    var isSet = true;
    print('Checking set...');
    setState(() {
      if (markedCardIndices.length == 3) {
        var cardCombinations = [
          for (var index in markedCardIndices)
            allCardCombinations.elementAt(index)
        ];
        for (var group = 0; group < numberOfVariables; group++) {
          var groupSum = 0;
          for (var cardCombination in cardCombinations) {
            groupSum += cardCombination.elementAt(group);
          }
          if (invalidSums.contains(groupSum)) isSet = false;
        }
        if (isSet) {
          print('Congratulations!');
        } else {
          print('Nope');
          markedCardIndices.clear();
        }
      } else {
        isSet = false;
      }
      if (isSet) {
        deckCardIndices.shuffle();

        for (var oldCardIndex in markedCardIndices) {
          int newCardIndex = deckCardIndices.elementAt(0);
          deckCardIndices.removeAt(0);
          var tableIndex = tableCardIndices.indexOf(oldCardIndex);
          tableCardIndices.removeAt(tableIndex);
          tableCardIndices.insert(tableIndex, newCardIndex);
          deckCardIndices.add(oldCardIndex);
        }
        markedCardIndices.clear();
      }
    });
  }

  List<Widget> buildCardRows() {
    final currentCards = buildCards();
    final widgets = [
      for (int ii = 0; ii < nRows; ii++)
        Expanded(
            child: Row(children: [
          for (int jj = 0; jj < nColumns; jj++)
            currentCards.elementAt(ii * nColumns + jj)
        ]
                // children: this.activeCards.sublist(ii, ii + this.nColumns
                ))
    ];
    return widgets;
  }

  List<PlayingCard> buildCards() => [
        for (int index in nextIndices().toList())
          PlayingCard(
              cardIndex: index,
              isSelected: markedCardIndices.contains(index),
              onSelected: (PlayingCard card) => setCardMarked(card))
      ];

  List<int> nextIndices() {
    var myNextIndices = <int>[];
    deckCardIndices.shuffle();
    if (tableCardIndices.length == 12) {
      myNextIndices = tableCardIndices.cast<int>();
    } else if (tableCardIndices.isEmpty) {
      tableCardIndices = deckCardIndices.sublist(0, 12).cast<int>();
      deckCardIndices.removeRange(0, 12);
      myNextIndices = tableCardIndices.cast<int>();
    }
    return myNextIndices;
  }
}

class PlayingCard extends StatefulWidget {
  final int cardIndex;
  final bool isSelected;
  final Function onSelected;

  PlayingCard({
    required this.cardIndex,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _PlayingCardState createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  final Color pinkColor = Color(0xffffa8cb);

  final Color purpleColor = Color(0xff784283);

  final Color redColor = Color(0xffe5000c);

  final Color blackColor = Color(0xff000000);

  final Color goldColor = Color(0xffffbf00);

  final Color blueColor = Color(0xff82a5df);

  List<int> myCardCombination() {
    return allCardCombinations.elementAt(widget.cardIndex);
  }

  int myShapeIndex() {
    return myCardCombination().elementAt(0) - 1;
  }

  int myColorIndex() {
    return myCardCombination().elementAt(1) - 1;
  }

  int myTextureIndex() {
    return myCardCombination().elementAt(2) - 1;
  }

  int myNumberIndex() {
    return myCardCombination().elementAt(3);
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

  Widget myIconShape() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      child: CustomPaint(
          painter: ShapePainter(
        myShapeIndex(),
        myColor(),
        myTextureIndex(),
        myNumberIndex(),
        queryData.size.height * 0.03,
      )),
    );
  }

  void toggleSelected() {
    widget.onSelected(widget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Card(
          shape: widget.isSelected
              ? RoundedRectangleBorder(
                  side: BorderSide(color: goldColor, width: 5.0),
                  borderRadius: BorderRadius.circular(4.0))
              : RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0),
                  borderRadius: BorderRadius.circular(4.0)),
          color: blueColor,
          child: InkWell(
            onTap: () {
              toggleSelected();
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
    final centerX = size.width / 2;

    final paint = Paint()
      ..color = shapeColor
      ..strokeWidth = 8.0;

    switch (shapeTexture) {
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
          colors: [shapeColor, Colors.white, shapeColor, Colors.white],
          tileMode: TileMode.repeated,
        ).createShader(Rect.fromCircle(
            center: Offset(size.width / 2, 0), radius: shapeSize / 2));
        break;
    }

    var path = Path();
    var myRectangles = <Rect>[];

    switch (shapeNumber) {
      case 1:
        var myRect =
            Offset(centerX - shapeSize, 0) & Size(3 * shapeSize, shapeSize);

        myRectangles.add(myRect);
        break;
      case 2:
        var myRect1 = Offset(centerX - shapeSize, -shapeSize) &
            Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect1);

        var myRect2 = Offset(centerX - shapeSize, shapeSize) &
            Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect2);
        break;
      case 3:
        var myRect1 = Offset(centerX - shapeSize, -2 * shapeSize) &
            Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect1);

        var myRect2 =
            Offset(centerX - shapeSize, 0) & Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect2);

        var myRect3 = Offset(centerX - shapeSize, 2 * shapeSize) &
            Size(3 * shapeSize, shapeSize);

        myRectangles.add(myRect3);
        break;
    }

    for (var myRect in myRectangles) {
      switch (shapeShape) {
        case 0:
          path.addRRect(RRect.fromRectAndRadius(myRect, Radius.circular(15)));
          break;
        case 1:
          path.addOval(myRect);
          break;
        case 2:
          var dx = myRect.center.dx;
          var dy = myRect.center.dy;
          var height = shapeSize * 0.9;
          if (shapeTexture == 1) height = height * 0.8;
          path.moveTo(dx - height, dy);
          path.lineTo(dx, dy + height);
          path.lineTo(dx + height, dy);
          path.lineTo(dx, dy - height);
          path.lineTo(dx - height, dy);
          path.close();

          // path.moveTo(centerX - this.shapeSize, 0);
          // path.lineTo(centerX, this.shapeSize);
          // path.lineTo(centerX + this.shapeSize, 0);
          // path.lineTo(centerX, -this.shapeSize);
          // path.lineTo(centerX - this.shapeSize, 0);
          // path.close();
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

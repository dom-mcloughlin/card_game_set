import 'package:cardgameset/data/card_data.dart';
import 'package:cardgameset/services/card_set_logic.dart';
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
  List<CardData> deckCards = allCards;
  List<CardData> tableCards = <CardData>[];
  Set markedCards = <CardData>{};

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

  void setCardMarked(PlayingCard playingCard) {
    setState(() {
      if (markedCards.contains(playingCard.card)) {
        markedCards.remove(playingCard.card);
      } else {
        markedCards.add(playingCard.card);
      }
      checkSet();
    });
  }

  void checkSet() {
    var isSet = true;
    print('Checking set...');
    setState(() {
      if (markedCards.length == 3) {
        if (isMatchingSet(List<CardData>.from(markedCards))) {
          isSet = true;
        } else {
          isSet = false;
        }
      } else {
        isSet = false;
      }
      if (isSet) {
        deckCards.shuffle();

        for (var oldCard in markedCards) {
          final newCard = deckCards.elementAt(0);
          deckCards.removeAt(0);
          var tableCardIndex = tableCards.indexOf(oldCard);
          tableCards.remove(oldCard);
          tableCards.insert(tableCardIndex, newCard);
          deckCards.add(oldCard);
        }
        markedCards.clear();
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
        ]))
    ];
    return widgets;
  }

  List<PlayingCard> buildCards() => [
        for (CardData card in nextCards())
          PlayingCard(
              card: card,
              isSelected: markedCards.contains(card),
              onSelected: (PlayingCard card) => setCardMarked(card))
      ];

  List<CardData> nextCards() {
    deckCards.shuffle();
    if (tableCards.length == 12) {
    } else if (tableCards.isEmpty) {
      tableCards = deckCards.sublist(0, 12);
      deckCards.removeRange(0, 12);
    }
    final n = allMatchingSets(tableCards).length;
    print('There are $n sets in this board');
    return tableCards;
  }
}

class PlayingCard extends StatelessWidget {
  final CardData card;
  final bool isSelected;
  final Function onSelected;

  PlayingCard({
    required this.card,
    required this.isSelected,
    required this.onSelected,
  });

  final Color pinkColor = Color(0xffffa8cb);

  final Color purpleColor = Color(0xff784283);

  final Color redColor = Color(0xffe5000c);

  final Color blackColor = Color(0xff000000);

  final Color goldColor = Color(0xffffbf00);

  final Color blueColor = Color(0xff82a5df);

  Widget myIconShape(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      child: CustomPaint(
        painter: ShapePainter(
          card,
          queryData.size.height * 0.03,
        ),
      ),
    );
  }

  void toggleSelected() {
    onSelected(this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Card(
          shape: isSelected
              ? RoundedRectangleBorder(
                  side: BorderSide(color: goldColor, width: 15.0),
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
                myIconShape(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final CardData card;
  final double shapeSize;

  ShapePainter(this.card, this.shapeSize);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    final paint = Paint()
      ..color = card.cardColor()
      ..strokeWidth = 8.0;

    switch (card.texture) {
      case ShapeTexture.solid:
        paint.style = PaintingStyle.fill;
        break;
      case ShapeTexture.empty:
        paint.style = PaintingStyle.stroke;
        break;
      case ShapeTexture.stripey:
        paint.style = PaintingStyle.fill;
        paint.shader = LinearGradient(
          begin: Alignment.topLeft,
          stops: [0.0, 0.5, 0.5, 1],
          colors: [
            card.cardColor(),
            Colors.white,
            card.cardColor(),
            Colors.white
          ],
          tileMode: TileMode.repeated,
        ).createShader(Rect.fromCircle(
            center: Offset(size.width / 2, 0), radius: shapeSize / 2));
        break;
    }

    final path = Path();
    var myRectangles = <Rect>[];

    switch (card.number) {
      case ShapeNumber.one:
        var myRect =
            Offset(centerX - shapeSize, 0) & Size(3 * shapeSize, shapeSize);

        myRectangles.add(myRect);
        break;
      case ShapeNumber.two:
        var myRect1 = Offset(centerX - shapeSize, -shapeSize) &
            Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect1);

        var myRect2 = Offset(centerX - shapeSize, shapeSize) &
            Size(3 * shapeSize, shapeSize);
        myRectangles.add(myRect2);
        break;
      case ShapeNumber.three:
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
      switch (card.shape) {
        case ShapeShape.rrect:
          path.addRRect(RRect.fromRectAndRadius(myRect, Radius.circular(15)));
          break;
        case ShapeShape.oval:
          path.addOval(myRect);
          break;
        case ShapeShape.diamond:
          var dx = myRect.center.dx;
          var dy = myRect.center.dy;
          var height = shapeSize * 0.9;
          if (card.texture == ShapeTexture.empty) height = height * 0.8;
          path.moveTo(dx - height, dy);
          path.lineTo(dx, dy + height);
          path.lineTo(dx + height, dy);
          path.lineTo(dx, dy - height);
          path.lineTo(dx - height, dy);
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

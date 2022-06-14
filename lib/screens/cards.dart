import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final List<String> _images = <String>[
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
  ];
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;

  @override
  void initState() {
    for (int i = 0; i < _images.length; i++) {
      _swipeItems.add(
        SwipeItem(
          content: buildCard(_images[i]),
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Liked'),
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Disliked'),
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      );
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Stack(
            children: [
              SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: _swipeItems[index].content,
                  );
                },
                onStackFinished: () {
                  Navigator.of(context).pushReplacementNamed('/finish');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String image) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: Colors.red,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              image: DecorationImage(
                image: Image.asset(image).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _matchEngine.currentItem!.like();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () {
                  _matchEngine.currentItem!.like();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

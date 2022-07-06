import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tinder/cubit/auth_cubit.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/routes.dart';
import 'package:tuple/tuple.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final List<Tuple2<String, String>> _idsAndImages = [];
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late final MatchEngine _matchEngine;

  void initIdsAndImages() {
    _idsAndImages.addAll(context.read<AppCubit>().idsAndImages);
  }

  @override
  void initState() {
    initIdsAndImages();
    for (int i = 0; i < _idsAndImages.length; i++) {
      _swipeItems.add(
        SwipeItem(
          content: buildCard(_idsAndImages[i].item2),
          likeAction: () {
            context.read<AppCubit>().addLike(_idsAndImages[i].item1);
            snackBar('Liked');
          },
          nopeAction: () {
            context.read<AppCubit>().addDislike(_idsAndImages[i].item1);
            snackBar('Disliked');
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
      floatingActionButton: TextButton(
        child: Text(
          'Выйти',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[500],
          ),
        ),
        onPressed: () {
          context.read<AppCubit>().clear();
          context.read<AuthCubit>().logOut();
          Navigator.of(context).pushReplacementNamed(Routes.auth);
        },
      ),
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
                  Navigator.of(context).pushReplacementNamed(Routes.finish);
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
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
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
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
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
                  _matchEngine.currentItem!.nope();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: const Icon(Icons.heart_broken,
                      size: 50, color: Colors.red),
                ),
              ),
              const SizedBox(
                width: 120,
              ),
              GestureDetector(
                onTap: () {
                  _matchEngine.currentItem!.like();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child:
                      const Icon(Icons.favorite, size: 50, color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      String string) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _idsAndImages.clear();
    super.dispose();
  }
}

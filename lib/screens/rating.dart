import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/rating_cubit.dart';
import 'package:tuple/tuple.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final List<Widget> _likedUsersWidget = [];
  final List<Widget> _dislikedUsersWidget = [];

  void getUsers() {
    List<Tuple2<String, String>> likedUsers =
        context.read<RatingCubit>().getLikedUsers();
    List<Tuple2<String, String>> dislikedUsers =
        context.read<RatingCubit>().getDislikedUsers();

    for (Tuple2 tuple in likedUsers) {
      _likedUsersWidget.add(_listItem(tuple.item1, tuple.item2));
    }
    for (Tuple2 tuple in dislikedUsers) {
      _dislikedUsersWidget.add(_listItem(tuple.item1, tuple.item2));
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple[400],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.favorite),
              ),
              Tab(
                icon: Icon(Icons.heart_broken),
              ),
            ],
          ),
          title: const Text('Оценки'),
        ),
        body: TabBarView(
          children: [
            ListView(children: _likedUsersWidget),
            ListView(children: _dislikedUsersWidget)
          ],
        ),
      ),
    );
  }

  Widget _listItem(String image, String name) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
              image: DecorationImage(
                image: Image.asset(image).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Container(
            height: 70,
            alignment: Alignment.centerRight,
            child: Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _likedUsersWidget.clear();
    _dislikedUsersWidget.clear();
    super.dispose();
  }
}

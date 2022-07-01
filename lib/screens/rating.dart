import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/cubit/app_cubit.dart';
import 'package:tinder/cubit/rating_cubit.dart';
import 'package:tuple/tuple.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final List<Tuple2<String, String>> _likedUsers = [];
  final List<Tuple2<String, String>> _dislikedUsers = [];
  final List<Widget> _likedUsersWidget = [];
  final List<Widget> _dislikedUsersWidget = [];

  Future<void> getLikedUsers() async {
    _likedUsers.addAll(await context.read<AppCubit>().getLikes());
    getLikedUsersWidget();
    context.read<RatingCubit>().setLikes();
  }

  void getLikedUsersWidget() {
    for (Tuple2 tuple in _likedUsers) {
      _likedUsersWidget.add(_listItem(tuple.item1, tuple.item2));
    }
  }

  void getDislikedUsers() async {
    _dislikedUsers.addAll(await context.read<AppCubit>().getDislikes());
    getDislikedUsersWidget();
  }

  void getDislikedUsersWidget() {
    for (Tuple2 tuple in _dislikedUsers) {
      _dislikedUsersWidget.add(_listItem(tuple.item1, tuple.item2));
    }
  }

  @override
  void initState() {
    _likedUsers.addAll(context.read<AppCubit>().likedUsers);
    _dislikedUsers.addAll(context.read<AppCubit>().dislikedUsers);
    if (_likedUsers.isEmpty || _dislikedUsers.isEmpty) {
      getLikedUsers();
      getDislikedUsers();
    } else {
      getLikedUsersWidget();
      getDislikedUsersWidget();
    }
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
              Tab(icon: Icon(Icons.favorite)),
              Tab(icon: Icon(Icons.heart_broken)),
            ],
          ),
          title: const Text('Оценки'),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<RatingCubit, RatingState>(
              builder: (context, state) {
                if (state is RatingLikes) {
                  return ListView(
                    children: _likedUsersWidget,
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple[400],
                      ),
                    ),
                  );
                }
              },
            ),
            ListView(
              children: _dislikedUsersWidget,
            ),
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
}

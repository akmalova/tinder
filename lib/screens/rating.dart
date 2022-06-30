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
  final List<Widget> _likedUsers = [];
  final List<Widget> _dislikedUsers = [];
  late final Timer _timer1;
  late final Timer _timer2;

  Future<void> getLikedUsers() async {
    List<Tuple2<String, String>> likedUsers =
        await context.read<AppCubit>().getLikes();
    for (Tuple2 tuple in likedUsers) {
      _likedUsers.add(_listItem(tuple.item1, tuple.item2));
    }
  }

  Future<void> getDislikedUsers() async {
    List<Tuple2<String, String>> dislikedUsers =
        await context.read<AppCubit>().getDislikes();
    for (Tuple2 tuple in dislikedUsers) {
      _dislikedUsers.add(_listItem(tuple.item1, tuple.item2));
    }
  }

  @override
  void initState() {
    _timer1 = Timer(const Duration(seconds: 1), getLikedUsers);
    _timer2 = Timer(const Duration(seconds: 1), getDislikedUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
        backgroundColor: Colors.deepPurple[400],
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<RatingCubit>().selLikes();
            },
            child: const Text('Лайки',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              context.read<RatingCubit>().selDislikes();
            },
            child: const Text('Дизлайки',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
      body: BlocBuilder<RatingCubit, RatingState>(
        builder: (context, state) {
          if (state is RatingLikes) {
            return ListView(
              children: _likedUsers,
            );
          } else if (state is RatingDislikes) {
            return ListView(
              children: _dislikedUsers,
            );
          } else {
            return Center(
              child: Text(
                'Выберите, что вы хотите посмотреть',
                style: TextStyle(fontSize: 20, color: Colors.grey[500]),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _listItem(String image, String name) {
    return Container(
      margin: const EdgeInsets.all(10),
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
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset(image).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          BlocBuilder<RatingCubit, RatingState>(
            builder: (context, state) {
              if (state is RatingLikes) {
                return Icon(Icons.favorite, color: Colors.deepPurple[400]);
              } else {
                return Icon(Icons.heart_broken, color: Colors.deepPurple[400]);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    _likedUsers.clear();
    _dislikedUsers.clear();
    super.dispose();
  }
}

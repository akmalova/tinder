part of 'rating_cubit.dart';

@immutable
abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLikes extends RatingState {}

class RatingDislikes extends RatingState {}

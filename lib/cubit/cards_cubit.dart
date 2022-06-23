import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  CardsCubit() : super(CardsInitial());
}

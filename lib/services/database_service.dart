import 'package:firebase_database/firebase_database.dart';
import 'package:tinder/models/app_user.dart';

class DatabaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<int> getUsersCount() async {
    DataSnapshot dataSnapshot = await databaseReference.get();
    return dataSnapshot.children.length;
  }

  // Получить айди, имя и изображение всех пользователей
  Future<List<Map<String, String>>> getUsers() async {
    DataSnapshot dataSnapshot = await databaseReference.get();
    Iterable<DataSnapshot> dataSnapshotIter = dataSnapshot.children;
    List<Map<String, String>> users = [];

    // Цикл по всем пользователям
    for (int i = 0; i < dataSnapshotIter.length; i++) {
      Iterable<DataSnapshot> userSnapshotIter =
          dataSnapshotIter.elementAt(i).children;
      Map<String, String> user = {};

      // Цикл по данным одного пользователя
      for (int j = 0; j < userSnapshotIter.length; j++) {
        String? key = userSnapshotIter.elementAt(j).key;
        Object? value = userSnapshotIter.elementAt(j).value;
        if (key == 'name' || key == 'id' || key == 'image') {
          user[key!] = value.toString();
        }
      }
      users.add(user);
    }
    return users;
  }

  Future<void> setUserData(AppUser user) async {
    await databaseReference.child(user.id).set(user.toMap());
  }

  // Получить данные текущего пользователя
  Future<Map<String, dynamic>> getUserData(String id) async {
    DataSnapshot dataSnapshot = await databaseReference.child(id).get();
    Iterable<DataSnapshot> dataSnapshotIter = dataSnapshot.children;
    Map<String, dynamic> data = {};
    for (int i = 0; i < dataSnapshotIter.length; i++) {
      data[dataSnapshotIter.elementAt(i).key!] =
          dataSnapshotIter.elementAt(i).value;
    }
    return data;
  }
}

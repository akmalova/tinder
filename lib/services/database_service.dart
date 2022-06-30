import 'package:firebase_database/firebase_database.dart';
import 'package:tinder/models/app_user.dart';

class DatabaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> setData(AppUser user) async {
    await databaseReference.child(user.id).set(user.toMap());
  }

  Future<Map<String, dynamic>> getData(String id) async {
    DataSnapshot snapshot = await databaseReference.child(id).get();
    Iterable<DataSnapshot> dataSnapshots = snapshot.children;
    Map<String, dynamic> data = {};
    for (int i = 0; i < dataSnapshots.length; i++) {
      data[dataSnapshots.elementAt(i).key!] = dataSnapshots.elementAt(i).value;
    }
    return data;
  }
}
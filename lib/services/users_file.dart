import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class UsersFile {
  static Future<File> getFile() async {
    Directory directory = await path_provider.getApplicationSupportDirectory();
    return File('${directory.path}/users.txt');
  }

  static Future<void> createFile(File file) async {
    file.create();
    String fileData = await rootBundle.loadString('assets/first_users.txt');
    file.writeAsString(fileData);
  }

  static Future<void> addUser(String id) async {
    File file = await getFile();
    //file.delete(); // для отладки
    if (!await file.exists()) {
      // получим готовых пользователей из файла
      createFile(file);
    }
    // добавим новых пользователей в локальный файл
    file.writeAsString(
        '$id assets/images/${await UsersFile.usersCount() + 1}.jpg\n',
        mode: FileMode.append);
  }

  static Future<int> usersCount() async {
    File file = await getFile();
    if (!await file.exists()) {
      createFile(file);
    }
    final List<String> lines = await file.readAsLines();
    return lines.length;
  }

  static Future<Map<String, String>> getUsers() async {
    File file = await getFile();
    if (!await file.exists()) {
      createFile(file);
    }
    final List<String> lines = await file.readAsLines();
    //print('LINES $lines');
    Map<String, String> users = {};
    for (String line in lines) {
      List<String> list = line.split(' ');
      users[list[0]] = list[1];
    }
    //print('USERS $users');
    return users;
  }
}

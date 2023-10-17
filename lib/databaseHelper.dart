import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static late Database db;

  static openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myDb');

    db=await openDatabase(path,version: 1,onCreate: (db, version) async {
      await db.execute("create table location(latitude text, longitude text,time text)");
    },);
  }

  static closeDb() async {
    await db.close();
  }
}
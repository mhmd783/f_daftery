import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'wael.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }


  _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''
  CREATE TABLE "users" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "name" TEXT NOT NULL,
    "mony" INTEGER NOT NULL,
    "who" TEXT NOT NULL
  )
''');
    batch.execute('''
  CREATE TABLE "rel" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "id_user" INTEGER NOT NULL,
    "pay" INTEGER NOT NULL,
    "get" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "weight" DOUBLE NOT NULL,
    "number" INTEGER NOT NULL,
    "time" TEXT NOT NULL,
    "date" TEXT NOT NULL
  )
''');
    await batch.commit();
    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}




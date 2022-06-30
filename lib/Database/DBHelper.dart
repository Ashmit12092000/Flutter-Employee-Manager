
import 'package:sqflite/sqflite.dart';

import 'DBConnector.dart';

//DBHelper
class DBHelper {
  late DBConnector _mConnection;
  DBHelper() {
    _mConnection = DBConnector();
  }

  static Database? _mdatabase;
  Future<Database?> get database async {
    if (_mdatabase != null) {
      return _mdatabase;
    } else {
      _mdatabase = await _mConnection.setDatabase();
      return _mdatabase;
    }
  }

  getDatabase() {
    return _mdatabase;
  }

  createTable(tableName) async {
    var connection = await database;
    String sql =
        "CREATE TABLE IF NOT EXISTS $tableName (EMPID INTEGER PRIMARY KEY,EMPNAME TEXT,EMPMOBILE TEXT,DOJ TEXT,AGE TEXT,isActive TEXT);";
    return await connection?.rawQuery(sql);
  }

  insert(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  getList(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  getListById(table, id) async {
    var connection = await database;
    return await connection?.rawQuery("Select * from $table where mOrganizationID = $id");
    
    
  }

  getData(table, qid) async {
    var connection = await database;
    return connection?.query(table, where: 'id=?', whereArgs: [qid]);
  }

  getUser(tablename, email, password) async {
    var connection = await database;
    String query =
        "Select email,password from $tablename where email='$email' and password = '$password';";
    var result = await connection?.rawQuery(query);
    if (result != null) {
      if (result.length > 0) {
        //return UserModel.fromMap(result.first);
      }
    }
    return null;
  }

  update(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, qid) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=?", [qid]);
  }
}

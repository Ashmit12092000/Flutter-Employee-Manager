// ignore_for_file: empty_catches, unused_import, import_of_legacy_library_into_null_safe

import 'package:employee_manager_zylu_task/Model/EmplyeeModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBConnector {
  var database;
  Future<Database> setDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, 'lzDBSlllll.db');
    //await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  getDatabase() {
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String employeeTableName = EmployeeModel.KEY_EMPLOYEE_TABLE_NAME;

    String createTableSql =
        "CREATE TABLE IF NOT EXISTS $employeeTableName (EMPID INTEGER PRIMARY KEY,EMPNAME TEXT,EMPMOBILE TEXT,DOJ TEXT,AGE TEXT,isActive TEXT);";
    //await database.execute(quesTableSql);

    //await database.execute(userTableSql);
  }
}

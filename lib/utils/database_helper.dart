import 'dart:async';
import 'dart:io';
import 'package:countryfrapp/model/country.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{
  static Database? _db;
  static const String countryTable = 'countryTable';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnLanguage = 'language';
  static const String columnCode ='code';
  static const String columnLongitude = 'longitude';
  static const String columnLatitude = 'latitude';


  //reference to database
  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  //opens the database (and creates it if it doesn't exist)
  initDB() async{
    Directory databasePath = await getApplicationDocumentsDirectory();
    String path = join(databasePath.path, 'countries.db');
    var db = await openDatabase(path, version:1,
        onCreate: _onCreate);
    return db;
  }

  //SQL code to create the database
  void _onCreate(Database db,int newVersion) async{
    var sql = 'CREATE TABLE $countryTable ($columnId INTEGER PRIMARY KEY,'
        ' $columnName TEXT, $columnLanguage TEXT,  $columnCode TEXT,$columnLongitude TEXT, $columnLatitude TEXT )';
    await db.execute(sql);
  }

  Future<int> saveCountry(Country country) async{
    var dbClient = await db;
    int result = await dbClient!.insert(countryTable, country.toMap());
    return result;
  }
  Future<List> getAllCountries() async{
    var dbClient = await db;
    var result = await dbClient!.query(
        countryTable,
        columns: [columnId, columnName, columnLanguage, columnCode,
          columnLongitude, columnLatitude]
    );
    // var sql = "SELECT * FROM $countryTable";
    // List result = await dbClient!.rawQuery(sql);
    return result.toList();
  }
  Future<int?> getCount() async{
    var dbClient = await  db;
    var sql = "SELECT COUNT(*) FROM $countryTable";

    return  Sqflite.firstIntValue(await dbClient!.rawQuery(sql)) ;
  }
  Future<Country?> getCountry(int id) async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $countryTable WHERE $columnId = $id";
    var result = await dbClient!.rawQuery(sql);
    if(result.isEmpty) return null;
    return  Country.fromMap(result.first) ;
  }

  //delete query
  Future<int> deleteCountry(int? id) async{
    var dbClient = await  db;
    return  await dbClient!.delete(
        countryTable, where: "$columnId = ?" , whereArgs: [id]
    );
  }

  //update query
  Future<int> updateCountry(Country country) async{
    var dbClient = await  db;
    return  await dbClient!.update(
        countryTable ,country.toMap(), where: "$columnId = ?" , whereArgs: [country.id]
    );
  }

  //close the database
  Future<void> close() async{
    var dbClient = await  db;
    return  await dbClient!.close();
  }

}
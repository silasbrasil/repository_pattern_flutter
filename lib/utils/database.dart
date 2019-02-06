import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {

  static Database _db;

  static Future<Database> get db async {
    if (_db != null) return _db;

    _db = await _initDb();

    return _db;
  }

  static Future<Database> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, "niduu.db");
    final database = await openDatabase(path, version: 1, onCreate: _onCreate);

    return database;
  }

  static void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS user (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created User table");

    await db.execute("""
      CREATE TABLE IF NOT EXISTS home_campaigns (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created Home Campaigns table");

    await db.execute("""
      CREATE TABLE IF NOT EXISTS home_courses (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created Home Courses table");

    await db.execute("""
      CREATE TABLE IF NOT EXISTS campaign (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created Campaign table");

    await db.execute("""
      CREATE TABLE IF NOT EXISTS course (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created Course table");

    await db.execute("""
      CREATE TABLE IF NOT EXISTS lesson (
        id INTEGER PRIMARY KEY,
        expires_at TEXT,
        json TEXT
      )""");
    print("Created Lesson table");
  }
}
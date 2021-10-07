import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('tasks.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tasksTable ( 
  ${TasksFields.id} $idType, 
  ${TasksFields.title} $textType,
  ${TasksFields.description} $textType,
  ${TasksFields.creatDate} $textType
  )
''');
  }

  Future<TaskModel> create(TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert(tasksTable, task.toJson());
    return task.copy(id: id);
  }

  Future<List<TaskModel>> readAllTasks() async {
    final db = await instance.database;

    final orderBy = '${TasksFields.creatDate} DESC';

    final result = await db.query(tasksTable, orderBy: orderBy);

    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<int> update(TaskModel task) async {
    final db = await instance.database;

    return db.update(
      tasksTable,
      task.toJson(),
      where: '${TasksFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tasksTable,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

import 'package:todo/services/database.dart';

class HomeRepository {
  Future getTask() async {
    var tasks = await TasksDatabase.instance.readAllTasks();

    return tasks;
  }

  Future deleteTask(int id) async {
    await TasksDatabase.instance.delete(id);
  }
}

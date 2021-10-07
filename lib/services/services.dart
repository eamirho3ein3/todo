import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

import 'package:todo/pages/new-task/new-task.dart';

void openNewTaskModal(
    {@required BuildContext context,
    @required double statusBarHeight,
    @required bool editMode,
    @required Function whenComplete,
    TaskModel task}) async {
  bool result = await showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: const Radius.circular(30.0)),
    ),
    context: context,
    builder: (context) => NewTask(
      editMode,
      task: task,
    ),
  );

  if (result != null && result) {
    whenComplete();
  }
}

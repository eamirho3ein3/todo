import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/global-variable.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/home/home-bloc.dart';
import 'package:todo/services/services.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function whenUpdateTaskComplete;
  final HomeBloc homeBloc;
  TaskItem(this.task, this.whenUpdateTaskComplete, this.homeBloc);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Icon(
            Icons.delete,
            color: Colors.black87,
          ),
          onTap: () => homeBloc.add(DeleteTask(task.id)),
        ),
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Icon(
            Icons.edit,
            color: Colors.black87,
          ),
          onTap: () => openNewTaskModal(
              context: context,
              statusBarHeight: GlobVariable().getStatusBarHeight(),
              editMode: true,
              task: task,
              whenComplete: whenUpdateTaskComplete),
        ),
      ],
      child: InkWell(
        onTap: () {
          openNewTaskModal(
              context: context,
              statusBarHeight: GlobVariable().getStatusBarHeight(),
              editMode: true,
              task: task,
              whenComplete: whenUpdateTaskComplete);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.pink,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset(0, 6.0),
                    color: Colors.black38)
              ]),
          child: Text(
            task.title,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: "IRANSansMobile",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

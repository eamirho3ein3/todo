import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/database.dart';

class NewTask extends StatefulWidget {
  final bool isEdit;
  final TaskModel task;
  NewTask(this.isEdit, {this.task});

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      titleController = new TextEditingController(text: widget.task.title);
      descriptionController =
          new TextEditingController(text: widget.task.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                widget.isEdit
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.black87,
                        onPressed: _deleteTask,
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // task title
                _buildTextField(titleController, 'عنوان تسک جدید', null),

                Divider(
                  height: 40,
                ),

                // task description
                _buildTextField(descriptionController, 'توضیحات', 4),

                // conferm button
                _buildConfermButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTextField(
      TextEditingController controller, String placeholder, int maxLines) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 2, offset: Offset(0, 1.0), color: Colors.grey[200]),
      ]),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 13,
          fontFamily: "IRANSansMobile",
        ),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.black26),
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  _buildConfermButton() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isEdit ? _updateTask : _addNewTask,
        child: Text(
          'تایید',
          style: TextStyle(
            fontSize: 15,
            fontFamily: "IRANSansMobile",
          ),
        ),
      ),
    );
  }

  Future _addNewTask() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      final task = TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          creatDate: DateTime.now());

      await TasksDatabase.instance.create(task);
      Navigator.pop(context, true);
    }
  }

  Future _updateTask() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      final task = widget.task.copy(
        title: titleController.text,
        description: descriptionController.text,
      );

      await TasksDatabase.instance.update(task);

      Navigator.pop(context, true);
    }
  }

  Future _deleteTask() async {
    await TasksDatabase.instance.delete(widget.task.id);
    Navigator.pop(context, true);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/global-variable.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/home/home-bloc.dart';
import 'package:todo/pages/home/home-repository.dart';
import 'package:todo/pages/home/widgets/task-item.dart';
import 'package:todo/services/database.dart';
import 'package:todo/services/services.dart';

class Home extends StatefulWidget {
  const Home({key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TaskModel> _tasks = [];
  HomeBloc _homeBloc;

  @override
  void dispose() {
    TasksDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _statusBarHeight = MediaQuery.of(context).padding.top;
    GlobVariable().setStatusBarHeight(_statusBarHeight);

    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(HomeRepository()),
      child: Scaffold(
          appBar: AppBar(
            title: Text('To Do'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  openNewTaskModal(
                      context: context,
                      statusBarHeight: GlobVariable().getStatusBarHeight(),
                      editMode: false,
                      whenComplete: _whenNewUpdateTaskComplete);
                },
              ),
            ],
          ),
          body: _manageState(context)),
    );
  }

  _manageState(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        _homeBloc = context.read<HomeBloc>();
        if (state is HomeUninitialized) {
          // initial the screen
          context.read<HomeBloc>().add(GetTasks());
          return Container();
        } else if (state is HomeLoading) {
          // get tasks data
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              backgroundColor: Colors.black,
            ),
          );
        } else if (state is TaskReady) {
          // tasks data are ready
          _tasks = state.getResult;

          return _buildView(context);
        } else if (state is GetError) {
          // get error
          return _buildCenterMessage("خطایی رخ داده است");
        } else if (state is TaskDelete) {
          // task delete
          context.read<HomeBloc>().add(GetTasks());

          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildView(BuildContext context) {
    return _tasks.isEmpty
        ? _buildCenterMessage("لیست شما خالی می باشد")
        : ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return TaskItem(
                  _tasks[index], _whenNewUpdateTaskComplete, _homeBloc);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12,
              );
            },
            itemCount: _tasks.length);
  }

  _whenNewUpdateTaskComplete() {
    _homeBloc.add(Reset());
  }

  _buildCenterMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 15,
          fontFamily: "IRANSansMobile",
          color: Colors.black45,
        ),
      ),
    );
  }
}

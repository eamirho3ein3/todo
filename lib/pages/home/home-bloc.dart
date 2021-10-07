import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/home/home-repository.dart';

class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTasks extends HomeEvent {}

class DeleteTask extends HomeEvent {
  final int id;
  DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class Reset extends HomeEvent {}

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeLoading extends HomeState {}

class TaskReady extends HomeState {
  final List<TaskModel> _result;
  TaskReady(this._result);
  List<TaskModel> get getResult => _result;

  @override
  List<Object> get props => throw [_result];
}

class TaskDelete extends HomeState {}

class GetError extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;
  HomeBloc(this.homeRepository) : super(HomeUninitialized());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetTasks) {
      yield HomeLoading();
      try {
        List<TaskModel> result = await homeRepository.getTask();

        yield TaskReady(result);
      } catch (error) {
        print("error read from database : $error");

        yield GetError();
      }
    } else if (event is DeleteTask) {
      yield HomeLoading();
      try {
        await homeRepository.deleteTask(event.id);
        yield TaskDelete();
      } catch (error) {
        print("error delete a task : $error");
        yield GetError();
      }
    } else if (event is Reset) {
      yield HomeUninitialized();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  var currentIndex = 0;

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeNavBarState(index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }


  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, emoji TEXT, title TEXT, date TEXT, time TEXT,status TEXT)');
        debugPrint('Data base created');
      },
      onOpen: (database) {
        getAllDatabase(database);
      },
    ).then(
      (value) {
        debugPrint('Data base opened');
        database = value;
        emit(AppCreateDatabaseState());
      },
    );
  }

  Future insertToDatabase({
    required String emoji,
    required String title,
    required String date,
    required String time,
  }) {
    return database.transaction(
      (Transaction txn) async {
        txn
            .rawInsert(
          'INSERT INTO tasks(emoji, title, date, time, status) VALUES("$emoji", "$title",  "$date", "$time", "new")',
        )
            .then(
          (value) {
            debugPrint('row number $value inserted');
            emit(AppInsertDatabaseState());
            getAllDatabase(database);
          },
        );
      },
    );
  }

  void getAllDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('Select * FROM tasks').then(
      (values) {
        values.forEach(
          (element) {
            if (element['status'] == 'new') {
              newTasks.add(element);
              newTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            } else if (element['status'] == 'done') {
              doneTasks.add(element);
              doneTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            } else {
              archivedTasks.add(element);
              archivedTasks.sort(
                (b, a) => a['id'].compareTo(b['id']),
              );
            }
          },
        );
        emit(AppGetDatabaseState());
      },
    );
  }

  void updateDatabase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then(
      (value) {
        getAllDatabase(database);
        emit(AppUpdateDatabaseState());
      },
    );
  }

  void deleteDatabase({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then(
      (value) {
        getAllDatabase(database);
        emit(AppDeleteDatabaseState());
      },
    );
  }

  var isBottomSheetShown = false;
  var fabIcon = Icons.edit;

  void changeFabIcon(
    bool visibility,
    IconData icon,
  ) {
    isBottomSheetShown = visibility;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}

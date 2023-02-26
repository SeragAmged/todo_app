import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var taskController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: false, //cubit.tasks.isEmpty,
              builder: ((context) =>
                  const Center(child: CircularProgressIndicator())),
              fallback: ((context) => cubit.screens[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                      title: taskController.text,
                      date: dateController.text,
                      time: timeController.text,
                    )
                        .then(
                      (value) {
                        taskController.text = '';
                        dateController.text = '';
                        timeController.text = '';
                      },
                    ).catchError(
                      (error) {
                        print("an error occurred: $error");
                      },
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 20.0,
                        (context) => Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  title: 'Task',
                                  controller: taskController,
                                  prefix: const Icon(Icons.title_outlined),
                                  type: TextInputType.text,
                                  validated: (value) => value.isEmpty
                                      ? "Task can't be empty"
                                      : null,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  title: 'Time',
                                  readOnly: true,
                                  controller: timeController,
                                  prefix:
                                      const Icon(Icons.watch_later_outlined),
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    ).then(
                                      (time) {
                                        timeController.text =
                                            time!.format(context);
                                      },
                                    ).catchError(
                                      (error) {
                                        timeController.text = "";
                                      },
                                    );
                                  },
                                  validated: (value) => value.isEmpty
                                      ? "Time can't be empty"
                                      : null,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  title: 'Date',
                                  readOnly: true,
                                  controller: dateController,
                                  prefix: const Icon(Icons.date_range_outlined),
                                  type: TextInputType.datetime,
                                  onTap: () async {
                                    try {
                                      var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-12-31'),
                                        helpText: "new Text",
                                      );
                                      dateController.text =
                                          DateFormat.yMMMd().format(date!);
                                    } catch (error) {
                                      dateController.text = "";
                                    }
                                  },
                                  validated: (value) => value.isEmpty
                                      ? "Date can't be empty"
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then(
                    (value) {
                      cubit.changeFabIcon(false, Icons.edit);
                    },
                  ).catchError(
                    (error) {
                      print("an error occurred: $error");
                    },
                  );

                  cubit.changeFabIcon(true, Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeNavBarState(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt_rounded),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//tasks

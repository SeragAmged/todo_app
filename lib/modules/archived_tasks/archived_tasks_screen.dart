import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return ConditionalBuilder(
          condition: tasks.isEmpty,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.task,
                  color: Colors.black26,
                  size: 100.0,
                ),
                Text(
                  'No, Tasks yet, pleas Add some Tasks',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          fallback: (context) => ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(
              tasks: tasks[index],
              context: context,
            ),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length,
          ),
        );
      },
    );
  }
}

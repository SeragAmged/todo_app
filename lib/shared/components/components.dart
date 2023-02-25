import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  var function,
  required var validated,
  required TextInputType type,
  bool hide = false,
  required String title,
  required Widget prefix,
  var suffix,
  var onTap,
  var readOnly = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: hide,
    onFieldSubmitted: function,
    validator: validated,
    onTap: onTap,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: title,
      border: const OutlineInputBorder(),
      prefixIcon: prefix,
      suffix: suffix,
    ),
  );
}

Widget buildTaskItem({required Map tasks, context}) {
  return Dismissible(
    key: Key(tasks['id'].toString()),
    onDismissed: (direction) => AppCubit.get(context).deleteDatabase(
      id: tasks['id'],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              tasks['time'],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  tasks['title'],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tasks['date'],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'done',
                id: tasks['id'],
              );
            },
            icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'archive',
                id: tasks['id'],
              );
            },
            icon: const Icon(Icons.archive),
            color: Colors.black26,
          ),
        ],
      ),
    ),
  );
}

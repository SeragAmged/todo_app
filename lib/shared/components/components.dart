import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

Widget buildTaskItem(
    {required Map tasks,
    required bool showArchiveIcon,
    required bool showDoneIcon,
    context}) {
  return Slidable(
    key: Key(tasks['id'].toString()),
    endActionPane: ActionPane(motion: const StretchMotion(), children: [
      SlidableAction(
        onPressed: (direction) =>
            AppCubit.get(context).deleteDatabase(id: tasks['id']),
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(4),
        icon: Icons.delete,
      )
    ]),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Text(
            tasks['emoji'],
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
          Text(
            tasks['time'],
          ),
          showDoneIcon
              ? IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'done',
                      id: tasks['id'],
                    );
                  },
                  icon: const Icon(Icons.check_box),
                  color: Colors.green,
                  padding: const EdgeInsets.only(left: 8),
                  constraints: const BoxConstraints(),
                )
              : const SizedBox(),
          showArchiveIcon
              ? IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'archive',
                      id: tasks['id'],
                    );
                  },
                  icon: const Icon(Icons.archive),
                  color: Colors.black26,
                  padding: const EdgeInsets.only(left: 8),
                  constraints: const BoxConstraints(),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

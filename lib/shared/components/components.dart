import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? onTap,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffixIcon),
              )
            : null,
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            IconButton(
              onPressed: () {
                if (model['status'] != 'done') {
                  AppCubit.get(context).updateData(
                    status: 'done',
                    id: model['id'],
                  );
                }
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                if (model['status'] != 'archive') {
                  AppCubit.get(context).updateData(
                    status: 'archive',
                    id: model['id'],
                  );
                }
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(
          id: model['id'],
        );
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    tasks.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length,
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  'No Tasks Yet, Please Add Some Tasks',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );

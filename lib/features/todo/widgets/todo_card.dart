import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final String task;
  final bool isCompleted;
  final VoidCallback delete;
  final VoidCallback toggleIsComplete;
  const ToDoCard({super.key,required this.task,required this.isCompleted,required this.delete,required this.toggleIsComplete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        toggleIsComplete();
      },
      child: Card(
        child: ListTile(
          contentPadding:const  EdgeInsets.all(0),
          title: Text(task,
              style: TextStyle(
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none)),
          leading: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Icon(!isCompleted
                  ? Icons.radio_button_unchecked
                  : Icons.radio_button_checked)),
          trailing: InkWell(
            onTap: () {
              delete();
            },
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey))),
                width: 60,
                height: double.infinity,
                child:const Icon(Icons.delete)),
          ),
        ),
      ),
    );
  }
}

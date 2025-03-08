import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

import '../service/database.dart';
class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController detailsController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Create new task",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 23, right: 23, top: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
                "Title",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
                ),
              ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left:10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)
              ) ,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),


            SizedBox(height: 10,),
            Text(
              "Details",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left:10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
              ) ,
              child: TextField(
                controller: detailsController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(onPressed: () async{
                String id= randomAlphaNumeric(10);
                Map<String,dynamic> taskInfo = {
                  "Title" :titleController.text,
                "Details": detailsController.text,
                "Id": id
                };
                await DatabaseMethods().addTask(taskInfo,id).then(
                    (value){
                      Fluttertoast.showToast(
                        msg: "Task is added successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                );
              },
                  child: Text(
                    "Add Task",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20
                    ),
                  ),
              ),
            )

          ],
        ),
      )
    );
  }
}
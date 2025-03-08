import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/database.dart';
import 'add_task.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController detailsController = new TextEditingController();
  Stream? TaskStream;
  getontheload() async {
    TaskStream = await DatabaseMethods().getAllTasks();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allTasks() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ds["Title"],
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(onTap: (){
                            titleController.text = ds["Title"];
                            detailsController.text = ds["Details"];
                            editTask(ds["Id"]);
                          },
                            child: Icon(Icons.edit, color: Colors.orange),
                          ),
                          SizedBox(width: 5.0,),
                          GestureDetector(
                            onTap: () async {
                              await DatabaseMethods().deleteTask(ds["Id"]).then((value){
                                Fluttertoast.showToast(
                                    msg: "Task is deleted successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });
                            },
                            child: Icon(Icons.delete, color: Colors.red,),
                          )

                        ],
                      ),
                      Text(
                        maxLines: 3,
                        "Details: " + ds["Details"],
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : Container();
      },
      stream: TaskStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tasks()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "TASKY",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "- Manage your tasks",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: allTasks())],
        ),
      ),
    );
  }

  Future editTask(String id) => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel),
                ),
                SizedBox(width: 60.0,),
                Text(
                  "Edit - Task",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Text(
              "Title",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: detailsController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 10,),

            Center(
              child: ElevatedButton(onPressed: () async{
                Map<String,dynamic> updateInfo ={
                  "Title": titleController.text,
                  "Details":detailsController.text,
                  "Id":id
                };
                await DatabaseMethods().updateTask(id, updateInfo).then((value){
                  Fluttertoast.showToast(
                      msg: "Task is updated successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.pop(context);
                });
              }, child: Text("Update")),
            )
          ],
        ),
      ),
    ),
  );
}
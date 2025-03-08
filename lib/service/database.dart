import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addTask(Map<String,dynamic> taskInfo, String id) async{
    return await FirebaseFirestore.instance
        .collection("task")
        .doc(id)
        .set(taskInfo);
  }
  Future<Stream<QuerySnapshot>> getAllTasks() async {
    return await FirebaseFirestore.instance.collection("task").snapshots();
  }

  Future updateTask(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("task")
        .doc(id)
        .update(updateInfo);
  }

  Future deleteTask(String id) async {
    return await FirebaseFirestore.instance.collection("task").doc(id).delete();
  }
}
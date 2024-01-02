import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_have_todo/app/services/storage_service.dart';
import 'package:i_have_todo/app/utils/date_time_utils.dart';
import 'package:i_have_todo/app/utils/device_utils.dart';

class TodoRepository {
  // init firebase

  // remove to do from firebase
  // update to do in firebase
  // get to do from firebase

  static Future<List<Map<String, dynamic>>> getTodo({
    DateTime? filterDate,
  }) async {
    String? deviceId = await getId();
    CollectionReference todo = FirebaseFirestore.instance.collection('todo');
    return await todo
        .where('deviceId', isEqualTo: deviceId)
        .get()
        .then((value) {
      List<Map<String, dynamic>> data = [];
      for (var element in value.docs) {
        if (filterDate != null) {
          if (isSameDay(
              filterDate,
              convertTimestampToDateTime(
                  (element.data() as dynamic)['dueDate']))) {
            data.add({
              'id': element.id,
              'title': (element.data() as dynamic)['title'],
              'description': (element.data() as dynamic)['description'],
              'isDone': (element.data() as dynamic)['isDone'],
              'createdAt': (element.data() as dynamic)['createdAt'],
              'updatedAt': (element.data() as dynamic)['updatedAt'],
              'dueDate': (element.data() as dynamic)['dueDate'],
              'isSetReminder': (element.data() as dynamic)['isSetReminder'],
              'attachments': (element.data() as dynamic)['attachments'],
            });
            continue;
          }
        } else {
          data.add({
            'id': element.id,
            'title': (element.data() as dynamic)['title'],
            'description': (element.data() as dynamic)['description'],
            'isDone': (element.data() as dynamic)['isDone'],
            'createdAt': (element.data() as dynamic)['createdAt'],
            'updatedAt': (element.data() as dynamic)['updatedAt'],
            'dueDate': (element.data() as dynamic)['dueDate'],
            'isSetReminder': (element.data() as dynamic)['isSetReminder'],
            'attachments': (element.data() as dynamic)['attachments'],
          });
        }
      }
      return data;
    }).catchError((error) {
      log(error.toString(), name: 'GET TODO');
    });
  }

  // add to do to firebase
  static Future<bool> addTodo({
    required String title,
    required String description,
    required List<File> files,
    int? dueDate,
    bool isSetReminder = false,
  }) async {
    CollectionReference todo = FirebaseFirestore.instance.collection('todo');
    String? deviceId = await getId();
    List<String> downloadUrls =
        await StorageBucketService.uploadAndGetDownloadUrl(files);
    return todo.add({
      'title': title,
      'description': description,
      'isDone': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'dueDate': DateTime.now().millisecondsSinceEpoch,
      'isSetReminder': isSetReminder,
      'deviceId': deviceId,
      'attachments': downloadUrls,
    }).then((value) {
      log(value.id.toString(), name: 'ADD TODO');
      return true;
    }).catchError((error) {
      log(error.toString(), name: 'ADD TODO');
      return false;
    });
  }

  // update  status to do in firebase

  static Future<bool> updateTodo({
    required String id,
    required bool isDone,
  }) async {
    CollectionReference todo = FirebaseFirestore.instance.collection('todo');
    return todo.doc(id).update({
      'isDone': isDone,
    }).then((value) {
      return true;
    }).catchError((error) {
      log(error.toString(), name: 'UPDATE TODO');
      return false;
    });
  }
}

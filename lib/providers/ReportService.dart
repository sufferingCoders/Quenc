// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:quenc/models/Report.dart';

// class ReportService with ChangeNotifier {
//   final Firestore _db = Firestore.instance;
//   final int _pageSize = 50;

//   /*******************************
//    *             ADD
//    *******************************/

//   /// Add Report to Firestore
//   Future<String> addReport(Report report) async {
//     var ref = _db.collection("reports").document();
//     report.id = ref.documentID;
//     await ref.setData(report.toMap());

//     return ref.documentID;
//   }

//   /*******************************
//    *             GET
//    *******************************/

//   /// Get all Reports
//   Future<List<Report>> getAllReports() async {
//     List<Report> retrivedReports = [];
//     var ref = _db.collection("reports").orderBy("createdAt");
//     var docs = await ref.getDocuments();

//     for (DocumentSnapshot d in docs.documents) {
//       retrivedReports.add(Report.fromMap(d.data));
//     }
//     return retrivedReports;
//   }

//   /// Get a single report by ID
//   Future<Report> getReportById(String id) async {
//     var doc = await _db.collection("reports").document(id).get();

//     if (!doc.exists) {
//       return null;
//     }

//     return Report.fromMap(doc.data);
//   }

//   /*******************************
//    *             UPDATE
//    *******************************/

//   /// Update a report by its ID and update fields
//   Future<bool> updateReport(
//       String id, Map<String, dynamic> updateFields) async {
//     try {
//       var ref = _db.collection("reports").document(id);
//       await ref.setData(updateFields, merge: true);
//       return true;
//     } catch (e) {
//       print("Update Report Error: ${e.toString()}");
//       return false;
//     }
//   }

//   /*******************************
//    *             DELETE
//    *******************************/

// }

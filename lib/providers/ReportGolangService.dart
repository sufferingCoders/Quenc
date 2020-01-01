import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/Report.dart';
import 'package:quenc/providers/UserGolangService.dart';

class ReportGolangService with ChangeNotifier {
  static const String baseUrl = "192.168.1.135:8080";
  static const String apiUrl = "http://" + baseUrl;

  Future<void> addReport(Report report) async {
    try {
      final url = apiUrl + "/report/";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(report.toAddingMap()),
      );

      if (res.body == null || res.body.isEmpty) {
        return;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Report>> getAllReports({
    OrderByOption orderBy = OrderByOption.CreatedAt,
    int skip = 0,
    int limit = 50,
  }) async {
    List<Report> retrivedReports = [];

    try {
      String url = apiUrl + "/report/?";

      if (skip != null) {
        url += "&skip=$skip";
      }

      if (limit != null) {
        url += "&limit=$limit";
      }

      switch (orderBy) {
        case OrderByOption.CreatedAt:
          url += "&sort=createdAt_-1";
          break;
        case OrderByOption.LikeCount:
          url += "&sort=likeCount_-1";
          break;
        default:
          break;
      }

      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<dynamic> reports = resData["reports"];

      for (var r in reports) {
        Report newReport = Report.fromMap(r);
        retrivedReports.add(newReport);
      }
      return retrivedReports;
    } catch (e) {
      throw e;
    }

    return retrivedReports;
  }

  Future<Report> getReportById(String id) async {
    Report report;

    try {
      final url = apiUrl + "/report/detail/$id";

      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      report = Report.fromMap(resData["report"]);
    } catch (e) {
      throw e;
    }

    return report;
  }

  Future<bool> updateReport(
      String id, Map<String, dynamic> updateFields) async {
    try {
      final url = apiUrl + "/report/$id";
      final res = await http.patch(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(updateFields),
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

enum OrderByOption {
  CreatedAt,
  LikeCount,
}

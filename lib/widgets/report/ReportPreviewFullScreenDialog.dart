import 'package:flutter/material.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/widgets/report/ReportShowingColumn.dart';

class ReportPreviweFullScreenDialog extends StatelessWidget {
  final Report report;

  ReportPreviweFullScreenDialog({this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("預覽"),
      ),
      body: SingleChildScrollView(
        child: ReportShowingColumn(report: report),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/widgets/common/CommentDivider.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';

class ReportShowingColumn extends StatelessWidget {
  const ReportShowingColumn({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CommentDivider(
          text: "舉報內容",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20.0),
          child: Text(
            "${DateFormat("h:mm a   dd, MMM, yyyy").format(report.createdAt)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        ContentShowingContainer(
          content: report.content,
        ),
      ],
    );
  }
}

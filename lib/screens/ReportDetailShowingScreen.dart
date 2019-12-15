import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/providers/CommentService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/ReportService.dart';
import 'package:quenc/widgets/comment/CommentShowingColumn.dart';
import 'package:quenc/widgets/common/CommentDivider.dart';
import 'package:quenc/widgets/post/PostShowingListTile.dart';
import 'package:quenc/widgets/report/ReportShowingColumn.dart';

class ReportDetailShowingScreen extends StatefulWidget {
  static const routeName = "/report/detail";
  final String reportId;
  final Report report;

  ReportDetailShowingScreen({
    this.reportId,
    this.report,
  });

  @override
  _ReportDetailShowingScreenState createState() =>
      _ReportDetailShowingScreenState();
}

class _ReportDetailShowingScreenState extends State<ReportDetailShowingScreen> {
  bool isInit = false;

  Report report;

  Comment comment;

  Post post;

  ReportTarget target;

  void setReportAndReportedItem() {
    if (widget.report == null) {
      setState(() async {
        report = await Provider.of<ReportService>(context)
            .getReportById(widget.reportId);
      });
    } else {
      report = widget.report;
    }

    target = Report.reportTargetIntToEnum(report.reportTarget);

    switch (target) {
      case ReportTarget.Comment:
        Provider.of<CommentService>(context)
            .getCommentById(report.reportId)
            .then((c) {
          setState(() {
            comment = c;
            isInit = true;
          });
        });
        break;
      case ReportTarget.Post:
        Provider.of<PostService>(context)
            .getPostByID(report.reportId)
            .then((p) {
          setState(() {
            post = p;
            isInit = true;
          });
        });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!isInit) {
      // get the report
      setReportAndReportedItem();
    }
    super.didChangeDependencies();
  }

  void refresh() {
    setState(() {
      report = null;
      comment = null;
      post = null;
    });

    setReportAndReportedItem();
  }

  Widget originalContentShowing() {
    if (target == ReportTarget.Comment && comment != null)
      return CommentShowingColumn(
        comment: comment,
      );
    else if (target == ReportTarget.Post && post != null)
      return PostShowingListTile(
        post: post,
      );
    else
      return Container(
        height: 100,
        child: Center(
          child: Text(
            target == ReportTarget.Post ? "原文已刪除" : "原評論已刪除",
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("舉報"),
          actions: <Widget>[
            if (report != null)
              IconButton(
                icon: Icon(
                  report.solve == true ? Icons.star : Icons.star_border,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    report.solve = !(report.solve == true);
                  });

                  var success =
                      await Provider.of<ReportService>(context).updateReport(
                    report.id,
                    {"solve": report.solve},
                  );

                  if (success != true) {
                    setState(() {
                      report.solve = !(report.solve == true);
                    });
                  }
                },
              )
          ],
        ),
        body: report == null
            ? isInit
                ? RefreshIndicator(
                    onRefresh: () async {
                      refresh();
                    },
                    child: Center(
                      child: Text("讀取舉報錯誤, 或該舉報不存在"),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
            : RefreshIndicator(
                onRefresh: () async {
                  refresh();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 60,
                        margin: EdgeInsets.all(10),
                        color: Colors.pink[200],
                        child: Center(
                            child: Text(
                          "${Report.reportTypeCodeToString(report.reportType)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      ReportShowingColumn(
                        report: report,
                      ),
                      CommentDivider(
                        text: "原文",
                      ),
                      originalContentShowing(),
                      const Divider(),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ));
  }
}

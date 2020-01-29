import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/widgets/report/ReportShowingListTile.dart';

enum ReportShowingOption {
  Solved,
  Unsolved,
  All,
}

class ReportManagementScreen extends StatefulWidget {
  static const routeName = "/report-management";

  @override
  _ReportManagementScreenState createState() => _ReportManagementScreenState();
}

class _ReportManagementScreenState extends State<ReportManagementScreen> {
  List<Report> reports;

  bool isInit = false;

  ReportShowingOption showingOption = ReportShowingOption.All;

  void setReports() {
    Provider.of<ReportGolangService>(context).getAllReports().then((r) {
      setState(() {
        reports = r;
        isInit = true;
      });
    });
  }

  void refresh() {
    setState(() {
      reports = null;
      isInit = false;
    });

    setReports();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      setReports();
    }
    super.didChangeDependencies();
  }

  List<Report> getshowingReports() {
    if (reports == null || reports.isEmpty) {
      return null;
    }

    if (showingOption == null) {
      return reports;
    }

    switch (showingOption) {
      case ReportShowingOption.Solved:
        return reports.where((r) => r.solve == true).toList();
        break;
      case ReportShowingOption.Unsolved:
        return reports.where((r) => r.solve != true).toList();
        break;
      case ReportShowingOption.All:
        return reports;
        break;
      default:
        break;
    }

    return reports;
  }

  Widget mainvBody(List<Report> showingReports) {
    return showingReports == null || showingReports.isEmpty
        ? isInit
            ? Center(
                child: Text("未有舉報"),
              )
            : Center(
                child: CircularProgressIndicator(),
              )
        : ListView.separated(
            separatorBuilder: (ctx, idx) {
              return const Divider();
            },
            itemCount: showingReports.length,
            itemBuilder: (ctx, idx) {
              return ReportShowingListTile(
                  context: context, report: showingReports[idx]);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    var showingReports = getshowingReports();

    return Scaffold(
      appBar: AppBar(
        title: Text("舉報管理"),
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
            iconEnabledColor: Colors.white,
            focusColor: Colors.white,
            value: showingOption,
            onChanged: (v) {
              setState(() {
                showingOption = v;
              });
            },
            items: [
              DropdownMenuItem<ReportShowingOption>(
                value: ReportShowingOption.All,
                child: Text(
                  "全部",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              DropdownMenuItem<ReportShowingOption>(
                value: ReportShowingOption.Solved,
                child: Text(
                  "已解決",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              DropdownMenuItem<ReportShowingOption>(
                value: ReportShowingOption.Unsolved,
                child: Text(
                  "未解決",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: mainvBody(showingReports),
      ),
    );
  }
}

class ReportDetailRouterArg {
  String reportId;
  Report report;

  ReportDetailRouterArg({this.report, this.reportId});
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/screens/ReportDetailShowingScreen.dart';
import 'package:quenc/screens/ReportManagementScreen.dart';
import 'package:quenc/utils/index.dart';

class ReportShowingListTile extends StatelessWidget {
  const ReportShowingListTile({
    Key key,
    @required this.context,
    @required this.report,
  }) : super(key: key);
  final Report report;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        color: report.author.gender == 1 ? Colors.blue : Colors.pink,
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          Utils.getDisplayNameFromDomain(report.author.domain),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${DateFormat("h:mm a   dd, MMM, yyyy").format(report.createdAt)}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              report.previewText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      trailing: Builder(
        builder: (context) {
          String photo = report.previewPhoto;

          if (photo == null || photo.isEmpty) {
            return Container(
              height: 1,
              width: 1,
            );
          }

          return Image.network(
            report.previewPhoto,
            fit: BoxFit.fill,
          );
        },
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          ReportDetailShowingScreen.routeName,
          arguments: ReportDetailRouterArg(
            report: report,
          ),
        );
      },
    );
  }
}

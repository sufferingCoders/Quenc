import 'package:clipboard_manager/clipboard_manager.dart' as cm;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:markdown/markdown.dart' as mk;
import 'package:url_launcher/url_launcher.dart';

class ContentShowingContainer extends StatelessWidget {
  const ContentShowingContainer({
    Key key,
    @required this.content,
  }) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
      child: Builder(
        builder: (context) {
          var mdText = mk.markdownToHtml(
            content.replaceAll("\n", "</br>"),
            extensionSet: mk.ExtensionSet.gitHubWeb,
          );

          return HtmlWidget(
            mdText,
            onTapUrl: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                cm.ClipboardManager.copyToClipBoard(url).then((r) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("無法顯示此網址, 但已將此網址複製至剪貼簿"),
                    duration: Duration(
                      seconds: 3,
                    ),
                  ));
                });
              }
            },
          );
        },
      ),
    );
  }
}

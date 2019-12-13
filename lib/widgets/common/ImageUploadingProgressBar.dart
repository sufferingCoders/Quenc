import 'package:flutter/material.dart';

class ImageUploadingProgressBar extends StatelessWidget {
  const ImageUploadingProgressBar({
    Key key,
    @required this.progressPercent,
  }) : super(key: key);

  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${(progressPercent * 100).toStringAsFixed(2)} % ',
          ),
          LinearProgressIndicator(
            value: progressPercent,
          ),
          Text(
            '上傳中',
            style: TextStyle(
              color: Colors.black,
              // height: 2,
            ),
          ),
        ]);
  }
}

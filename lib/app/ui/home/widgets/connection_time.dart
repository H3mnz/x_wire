import 'package:flutter/material.dart';

import '../../../shared/extension/duration_ext.dart';

class ConnectingTime extends StatelessWidget {
  const ConnectingTime({
    super.key,
    required this.duration,
  });
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.fromSize(
          size: textSize('00', Theme.of(context).textTheme.displayMedium),
          child: Text(
            duration.twoDigitHours,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
          ),
        ),
        SizedBox.fromSize(
          size: textSize(':', Theme.of(context).textTheme.displayMedium),
          child: Text(
            ':',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        SizedBox.fromSize(
          size: textSize('00', Theme.of(context).textTheme.displayMedium),
          child: Text(
            duration.twoDigitMinutes,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
          ),
        ),
        SizedBox.fromSize(
          size: textSize(':', Theme.of(context).textTheme.displayMedium),
          child: Text(
            ':',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        SizedBox.fromSize(
          size: textSize('00', Theme.of(context).textTheme.displayMedium),
          child: Text(
            duration.twoDigitSeconds,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

Size textSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

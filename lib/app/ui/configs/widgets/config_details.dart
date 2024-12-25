import 'package:flutter/material.dart';
import 'package:text_highlight_codespark/text_highlight_codespark.dart';

class ConfigDetails extends StatelessWidget {
  const ConfigDetails({
    super.key,
    required this.config,
  });

  final String config;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Config details', style: Theme.of(context).textTheme.titleLarge),
        Padding(
          padding: const EdgeInsets.all(16),
          child: HighlightText.multiple(
            queries: const ['Interface', 'Peer'],
            source: config,
            highlightColor: Colors.transparent,
            matchedTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
            caseSensitive: false,
          ),
        ),
      ],
    );
  }
}

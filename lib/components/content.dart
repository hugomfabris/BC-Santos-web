import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final Widget child;

  const Content({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(fit: FlexFit.loose, child: widget.child),
      ],
    );
  }
}

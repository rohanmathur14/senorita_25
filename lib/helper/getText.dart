import 'package:flutter/material.dart';

class getText extends StatefulWidget {
  final String title;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String fontFamily;
  final TextAlign textAlign;
  final double letterSpacing;
  final double lineHeight;
  final TextOverflow textOverflow;

  const getText(
      {key,
      required this.title,
      required this.size,
      required this.fontFamily,
      required this.color,
      required this.fontWeight,
      this.textAlign = TextAlign.start,
      this.letterSpacing = 0,
      this.lineHeight = 0,
      this.textOverflow =TextOverflow.ellipsis
      });

  @override
  State<getText> createState() => _getTextState();
}

class _getTextState extends State<getText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.title,
        textAlign: widget.textAlign,
        style: TextStyle(
          height: widget.lineHeight,
          color: widget.color,
          fontFamily: widget.fontFamily,
          fontSize: widget.size,
          fontWeight: widget.fontWeight,
          letterSpacing: widget.letterSpacing,
          overflow: widget.textOverflow,
        ),maxLines: 5,overflow: TextOverflow.ellipsis,);
  }
}

import 'package:flutter/material.dart';

class FitTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FitTextPage"),
      ),
      body: Column(
        children: [
          FitTextField(),
          IntrinsicWidth(child: TextField(controller: TextEditingController(text: "111"),),),
        ],
      ),
    );
  }
}

class FitTextField extends StatefulWidget {
  final String initialValue;
  final double minWidth;

  const FitTextField({this.initialValue: "value", this.minWidth: 30});

  @override
  State<StatefulWidget> createState() => new FitTextFieldState();
}

class FitTextFieldState extends State<FitTextField> {
  TextEditingController txt = TextEditingController();

  // We will use this text style for the TextPainter used to calculate the width
  // and for the TextField so that we calculate the correct size for the text
  // we are actually displaying
  TextStyle textStyle = TextStyle(color: Colors.grey[600]);

  initState() {
    super.initState();
    // Set the text in the TextField to our initialValue
    txt.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // Use TextPainter to calculate the width of our text
    TextSpan ts = TextSpan(style: textStyle, text: txt.text);
    TextPainter tp = TextPainter(text: ts, textDirection: TextDirection.ltr);
    tp.layout();
    var textWidth = tp
        .width; // We will use this width for the container wrapping our TextField

    // Enforce a minimum width
    if (textWidth < widget.minWidth) {
      textWidth = widget.minWidth;
    }

    return Container(
      width: textWidth,
      child: TextField(
        style: textStyle,
        controller: txt,
        onChanged: (text) {
          // Tells the framework to redraw the widget
          // The widget will redraw with a new width
          setState(() {});
        },
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class LoaderIndicator extends StatelessWidget {
  final double size;

  LoaderIndicator({this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: size,
        height: size,
      ),
    );
  }
}

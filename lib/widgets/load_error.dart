import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/generated/l10n.dart';

class LoadError extends StatelessWidget {
  final Object _error;

  LoadError(this._error);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(S.of(context).error(_error)),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kino_player/generated/l10n.dart';

class LoaderError extends StatelessWidget {
  final Object _error;
  final VoidCallback onRetry;

  LoaderError(this._error, {this.onRetry});

  @override
  Widget build(BuildContext context) {
    var widgets = [
      Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(S.of(context).error(_error)),
      ),
    ];
    if (onRetry != null) {
      widgets.add(FlatButton(
        autofocus: true,
        onPressed: onRetry,
        child: Text(S.of(context).retry),
      ));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
    );
  }
}

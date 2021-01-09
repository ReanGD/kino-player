import 'package:flutter/widgets.dart';
import 'package:kino_player/widgets/loader_error.dart';
import 'package:kino_player/widgets/loader_indicator.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T data);

class FutureWidget<T> extends StatefulWidget {
  final Future<T> future;
  final WidgetBuilder<T> builder;

  const FutureWidget({
    this.future,
    this.builder,
  })  : assert(future != null),
        assert(builder != null);

  @override
  createState() => _FutureWidgetState<T>();
}

class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  Object _activeCallbackIdentity;
  AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = AsyncSnapshot<T>.nothing();
    _subscribe();
  }

  @override
  void didUpdateWidget(FutureWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_snapshot.hasData) {
      return widget.builder(context, _snapshot.data);
    }
    if (_snapshot.hasError) {
      return LoaderError(_snapshot.error);
    }
    return const LoaderIndicator();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final Object callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      widget.future.then<void>((T data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
          });
        }
      }, onError: (Object error, StackTrace stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withError(
                ConnectionState.done, error, stackTrace);
          });
        }
      });
      _snapshot = _snapshot.inState(ConnectionState.waiting);
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }
}

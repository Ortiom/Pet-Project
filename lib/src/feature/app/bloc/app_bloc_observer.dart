import 'package:l/l.dart';
import 'package:purple_starter/src/core/logic/identity_logging_mixin.dart';
import 'package:stream_bloc/stream_bloc.dart';

extension on StringBuffer {
  /// Writes the type of the object in debug mode to make logs **readable** and
  /// write the object's [toString] in release mode to make logs
  /// **informative**.
  void writeInfo(Object? object) {
    Type? type;

    // ignore: prefer_asserts_with_message
    assert(
      () {
        type = object.runtimeType;

        return true;
      }(),
    );

    write(type ?? object);
  }
}

class AppBlocObserver extends StreamBlocObserver with IdentityLoggingMixin {
  const AppBlocObserver();

  @override
  void onCreate(Closable closable) {
    super.onCreate(closable);
    logData(
      (buffer) => buffer
        ..write('Created ')
        ..writeInfo(closable),
    );
  }

  @override
  void onEvent(BlocEventSink<Object?> eventSink, Object? event) {
    super.onEvent(eventSink, event);
    if (event != null) {
      logData(
        (buffer) => buffer
          ..write('Event ')
          ..writeInfo(event)
          ..write(' in ')
          ..writeInfo(eventSink),
      );
    }
  }

  @override
  void onTransition(BlocEventSink<Object?> bloc, Transition transition) {
    super.onTransition(bloc, transition);

    final Object? event = transition.event;

    if (event != null) {
      logData(
        (buffer) => buffer
          ..write('Transition in ')
          ..writeInfo(bloc)
          ..write(' with ')
          ..writeInfo(event)
          ..write(': ')
          ..writeInfo(transition.currentState)
          ..write(' -> ')
          ..writeInfo(transition.nextState),
      );
    }
  }

  @override
  void onError(ErrorSink errorSink, Object error, StackTrace stackTrace) {
    super.onError(errorSink, error, stackTrace);

    logData(
      (buffer) => buffer
        ..write('Error ')
        ..writeInfo(error)
        ..write(' in ')
        ..writeInfo(errorSink),
    );

    l.e(error, stackTrace);
  }

  @override
  void onClose(Closable closable) {
    super.onClose(closable);
    logData(
      (buffer) => buffer
        ..write('Closed ')
        ..writeInfo(closable),
    );
  }
}

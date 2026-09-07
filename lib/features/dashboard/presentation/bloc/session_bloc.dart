import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/session_manager.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionChecking()) {
    on<AppStarted>(_onAppStarted);
    on<SessionTicked>(_onSessionTicked);
  }

  Timer? _timer;

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<SessionState> emit,
  ) async {
    final isValid = await SessionManager.instance.isSessionValid();
    if (isValid) {
      _startTimer();
      emit(const SessionValid());
    } else {
      emit(const SessionExpired());
    }
  }

  Future<void> _onSessionTicked(
    SessionTicked event,
    Emitter<SessionState> emit,
  ) async {
    final isValid = await SessionManager.instance.isSessionValid();
    if (!isValid) {
      _cancelTimer();
      emit(const SessionExpired());
    }
  }

  void _startTimer() {
    _timer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => add(SessionTicked()),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}

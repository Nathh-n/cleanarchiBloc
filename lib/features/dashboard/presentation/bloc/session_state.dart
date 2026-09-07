sealed class SessionState {
  const SessionState();
}

final class SessionChecking extends SessionState {
  const SessionChecking();
}

final class SessionValid extends SessionState {
  const SessionValid();
}

final class SessionExpired extends SessionState {
  const SessionExpired();
}

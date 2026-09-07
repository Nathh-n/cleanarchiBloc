import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/bloc/session_bloc.dart';
import 'features/dashboard/presentation/bloc/session_event.dart';
import 'features/dashboard/presentation/bloc/session_state.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final (lightTheme, darkTheme) =
        const <TargetPlatform>{
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.fuchsia,
        }.contains(defaultTargetPlatform)
        ? (FTheme.neutral.light.touch, FTheme.neutral.dark.touch)
        : (FTheme.neutral.light.desktop, FTheme.neutral.dark.desktop);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) => SessionBloc()..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: FLocalizations.supportedLocales,
        localizationsDelegates: FLocalizations.localizationsDelegates,
        themeMode: ThemeMode.light,
        theme: lightTheme.toApproximateMaterialTheme(),
        darkTheme: darkTheme.toApproximateMaterialTheme(),
        builder: (context, child) => FTheme(
          data: Theme.brightnessOf(context) == Brightness.light
              ? lightTheme
              : darkTheme,
          child: FToaster(child: FTooltipGroup(child: child!)),
        ),
        home: const _SessionGate(),
      ),
    );
  }
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is SessionChecking) {
          return const FScaffold(
            childPad: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is SessionValid) {
          return const DashboardPage();
        }
        return const LoginPage();
      },
    );
  }
}

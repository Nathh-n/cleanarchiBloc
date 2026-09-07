import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final tabTitles = ['Upload Gambar', 'Daftar Produk'];

    return FScaffold(
      header: FHeader(
        title: Text(tabTitles[_currentTab]),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.logOut),
            semanticsTooltip: 'Logout',
            onPress: _handleLogout,
          ),
        ],
      ),
      footer: FBottomNavigationBar(
        index: _currentTab,
        onChange: (index) => setState(() => _currentTab = index),
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.uploadCloud),
            label: Text('Upload'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.list),
            label: Text('Produk'),
          ),
        ],
      ),
      child: BlocListener<SessionBloc, SessionState>(
        listener: (context, sessionState) {
          if (sessionState is SessionExpired) {
            _goToLogin();
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is AuthInitial) {
              _goToLogin();
            }
          },
          child: _buildTabContent(),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTab) {
      case 0:
        return const _PlaceholderContent(
          icon: FLucideIcons.uploadCloud,
          message: 'Fitur upload gambar segera hadir.',
        );
      case 1:
        return const _PlaceholderContent(
          icon: FLucideIcons.list,
          message: 'Fitur daftar produk segera hadir.',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await _confirmLogout();
    if (!confirmed || !mounted) return;

    context.read<AuthBloc>().add(LogoutRequested());
  }

  Future<bool> _confirmLogout() async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        animation: animation,
        builder: (context, style) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Keluar dari aplikasi?',
                style: style.titleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.outline,
                      onPress: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.destructive,
                      onPress: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return confirmed ?? false;
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  final IconData icon;
  final String message;

  const _PlaceholderContent({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

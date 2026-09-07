import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'john@mail.com');
  final _passwordController = TextEditingController(text: 'changeme');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  void _handleLogin() {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    context.read<AuthBloc>().add(
      LoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      child: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            } else if (state is AuthFailure) {
              showFToast(
                context: context,
                variant: FToastVariant.destructive,
                title: const Text('Login Gagal'),
                description: Text(state.message),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(FLucideIcons.lockKeyhole, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Masuk ke Akunmu',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      FTextFormField.email(
                        control: FTextFieldControl.managed(
                          controller: _emailController,
                        ),
                        label: const Text('Email'),
                        hint: 'contoh@mail.com',
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      FTextFormField.password(
                        control: FTextFieldControl.managed(
                          controller: _passwordController,
                        ),
                        label: const Text('Password'),
                        hint: 'Minimal 8 karakter',
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),
                      FButton(
                        onPress: isLoading ? null : _handleLogin,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

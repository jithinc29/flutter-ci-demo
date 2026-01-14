import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_gradient_background.dart';
import '../widgets/auth_icon_container.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/auth_page_header.dart';
import '../widgets/auth_snackbar.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_validators.dart';
import 'sign_up_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authControllerProvider.notifier);
    await notifier.signIn(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (err, __) => AuthSnackbar.showError(context, err.toString()),
      );
    });

    final state = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;
    final primaryColor = Colors.blue.shade700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthGradientBackground(
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.white,
            ],
            child: Container(
              height: size.height - MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    AuthIconContainer(
                      icon: Icons.lock_outline_rounded,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 32),
                    const AuthPageHeader(
                      title: 'Welcome Back',
                      subtitle: 'Sign in to continue',
                    ),
                    const Spacer(flex: 2),
                    AuthTextField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: AuthValidators.email,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      showPasswordToggle: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: AuthValidators.password,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 32),
                    AuthButton(
                      text: 'Sign In',
                      onPressed: _submit,
                      isLoading: state.isLoading,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 24),
                    AuthNavigationLink(
                      prefixText: "Don't have an account? ",
                      linkText: 'Sign Up',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
                        );
                      },
                      color: primaryColor,
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

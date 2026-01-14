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

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authControllerProvider.notifier);
    await notifier.signUp(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (err, __) => AuthSnackbar.showError(context, err.toString()),
        data: (_) => AuthSnackbar.showSuccess(
          context,
          'Account created successfully!',
        ),
      );
    });

    final state = ref.watch(authControllerProvider);
    final primaryColor = Colors.purple.shade700;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthGradientBackground(
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
              Colors.white,
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    AuthIconContainer(
                      icon: Icons.person_add_outlined,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 32),
                    const AuthPageHeader(
                      title: 'Create Account',
                      subtitle: 'Sign up to get started',
                    ),
                    const SizedBox(height: 40),
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
                      hint: 'Create a password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      showPasswordToggle: true,
                      textInputAction: TextInputAction.next,
                      validator: AuthValidators.password,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _confirmPasswordCtrl,
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      showPasswordToggle: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) => AuthValidators.confirmPassword(
                        value,
                        _passwordCtrl.text,
                      ),
                      color: primaryColor,
                    ),
                    const SizedBox(height: 32),
                    AuthButton(
                      text: 'Create Account',
                      onPressed: _submit,
                      isLoading: state.isLoading,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 24),
                    AuthNavigationLink(
                      prefixText: 'Already have an account? ',
                      linkText: 'Sign In',
                      onTap: () => Navigator.of(context).pop(),
                      color: primaryColor,
                    ),
                    const SizedBox(height: 40),
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

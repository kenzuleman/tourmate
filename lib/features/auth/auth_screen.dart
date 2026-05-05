import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/soft_card.dart';
import 'controllers/auth_controller.dart';
import 'utils/validators.dart';

enum _AuthMode { login, signup }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthMode _mode = _AuthMode.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _Header(mode: _mode),
              const SizedBox(height: 24),
              _ModeToggle(
                mode: _mode,
                onChanged: (m) => setState(() => _mode = m),
              ),
              const SizedBox(height: 20),
              SoftCard(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: _mode == _AuthMode.login
                    ? const _LoginForm()
                    : _SignupFlow(
                        onSwitchToLogin: () =>
                            setState(() => _mode = _AuthMode.login),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.mode});
  final _AuthMode mode;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Image.asset('assets/logo.png', width: 80, height: 80),
        const SizedBox(height: 16),
        Text(
          mode == _AuthMode.login ? 'Welcome back' : 'Create your account',
          style: text.headlineLarge?.copyWith(color: AppColors.green),
        ),
        const SizedBox(height: 6),
        Text(
          mode == _AuthMode.login
              ? 'Sign in to continue your journey'
              : 'Join TourMate and start exploring',
          style: text.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});
  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _ToggleSegment(
            label: 'Login',
            selected: mode == _AuthMode.login,
            onTap: () => onChanged(_AuthMode.login),
          ),
          _ToggleSegment(
            label: 'Sign Up',
            selected: mode == _AuthMode.signup,
            onTap: () => onChanged(_AuthMode.signup),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _errorBanner;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorBanner = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).signIn(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      if (!mounted) return;
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBanner = authErrorMessage(e);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBanner = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorBanner != null) ...[
            _ErrorBanner(message: _errorBanner!),
            const SizedBox(height: 14),
          ],
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: (_) {
              if (_errorBanner != null) {
                setState(() => _errorBanner = null);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: Validators.email,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            autofillHints: const [AutofillHints.password],
            onChanged: (_) {
              if (_errorBanner != null) {
                setState(() => _errorBanner = null);
              }
            },
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: Validators.loginPassword,
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

enum _SignupStep { form, success }

class _SignupFlow extends ConsumerStatefulWidget {
  const _SignupFlow({required this.onSwitchToLogin});

  final VoidCallback onSwitchToLogin;

  @override
  ConsumerState<_SignupFlow> createState() => _SignupFlowState();
}

class _SignupFlowState extends ConsumerState<_SignupFlow> {
  _SignupStep _step = _SignupStep.form;
  String _verifiedEmail = '';

  void _goToSuccess(String email) {
    setState(() {
      _verifiedEmail = email;
      _step = _SignupStep.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final incoming = child.key == const ValueKey(_SignupStep.success);
          final beginOffset =
              incoming ? const Offset(1, 0) : const Offset(-1, 0);
          final slide = Tween<Offset>(begin: beginOffset, end: Offset.zero)
              .animate(animation);
          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: _step == _SignupStep.form
            ? KeyedSubtree(
                key: const ValueKey(_SignupStep.form),
                child: _SignupForm(onSignedUp: _goToSuccess),
              )
            : KeyedSubtree(
                key: const ValueKey(_SignupStep.success),
                child: _SignupSuccessView(
                  email: _verifiedEmail,
                  onBackToLogin: widget.onSwitchToLogin,
                ),
              ),
      ),
    );
  }
}

class _SignupForm extends ConsumerStatefulWidget {
  const _SignupForm({required this.onSignedUp});

  final ValueChanged<String> onSignedUp;

  @override
  ConsumerState<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _prefsCtrl = TextEditingController();
  bool _obscure = true;
  bool _acceptedTerms = false;
  bool _termsError = false;
  bool _loading = false;
  String? _errorBanner;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _prefsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorBanner = null;
      _termsError = !_acceptedTerms;
    });
    final formValid = _formKey.currentState!.validate();
    if (!formValid || !_acceptedTerms) return;

    setState(() => _loading = true);
    final email = _emailCtrl.text.trim();
    try {
      await ref.read(authControllerProvider.notifier).signUp(
            username: _usernameCtrl.text.trim(),
            fullName: _nameCtrl.text.trim(),
            age: int.parse(_ageCtrl.text.trim()),
            email: email,
            password: _passwordCtrl.text,
            preferences: _prefsCtrl.text.trim(),
          );
      if (!mounted) return;
      widget.onSignedUp(email);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorBanner = e.message ?? e.code);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorBanner = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorBanner != null) ...[
            _ErrorBanner(message: _errorBanner!),
            const SizedBox(height: 14),
          ],
          TextFormField(
            controller: _usernameCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]')),
              LengthLimitingTextInputFormatter(24),
            ],
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'e.g. wanderlust.kim',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: Validators.username,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: Validators.name,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
            validator: Validators.age,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: Validators.email,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              helperText: 'Min 8 chars, 1 uppercase, 1 number, 1 special',
              helperMaxLines: 2,
              helperStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: Validators.password,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _prefsCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'AI Travel Preferences',
              hintText: 'e.g. mountains, budget, foodie, slow travel',
              prefixIcon: Icon(Icons.tune_rounded),
            ),
            validator: Validators.preferences,
          ),
          const SizedBox(height: 14),
          _TermsCheckbox(
            value: _acceptedTerms,
            onChanged: (v) => setState(() {
              _acceptedTerms = v ?? false;
              if (_acceptedTerms) _termsError = false;
            }),
            showError: _termsError,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

class _SignupSuccessView extends StatelessWidget {
  const _SignupSuccessView({
    required this.email,
    required this.onBackToLogin,
  });

  final String email;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.greenSoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.green,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Account created!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
            children: [
              const TextSpan(
                text: "We've sent a verification link to ",
              ),
              TextSpan(
                text: email,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const TextSpan(
                text:
                    '. Please check your inbox and verify your account before logging in.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onBackToLogin,
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
    required this.showError,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: const Text(
                  'I agree to the Terms & Conditions and Privacy Policy.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 4),
            child: Text(
              'Please accept the terms to continue',
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.danger.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

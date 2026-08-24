import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';

const _demoEmails = [
  'jane.smith@acme-construction.test',
  'tom.reid@acme-construction.test',
  'priya.naidoo@skylinefoods.test',
];

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(loginControllerProvider.notifier).login(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final bootstrap = ref.watch(authBootstrapProvider);

    // Attempting a silent refresh-token resume (14-day TTL, so most cold starts should
    // skip this screen entirely) before showing the form - see authBootstrapProvider.
    if (bootstrap.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(6)),
                          child: const Text('SZ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        const Text('SafeZone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Sign in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('Site safety & compliance tracking.', style: TextStyle(fontSize: 12, color: AppColors.sub)),
                    const SizedBox(height: 20),
                    const Text('EMAIL', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        if (value == null || !value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text('PASSWORD', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) => (value == null || value.isEmpty) ? 'Password is required' : null,
                    ),
                    if (loginState.hasError) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.redBg, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Invalid email or password.', style: TextStyle(fontSize: 11.5, color: AppColors.red)),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loginState.isLoading ? null : _submit,
                        child: Text(loginState.isLoading ? 'Signing in…' : 'Sign in'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    NoteBanner(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Demo credentials', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          const Text('Password for every demo user: SafeZone123!'),
                          const SizedBox(height: 4),
                          for (final email in _demoEmails) Text('• $email'),
                        ],
                      ),
                    ),
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

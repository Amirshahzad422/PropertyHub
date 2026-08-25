import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/utils/validators.dart';
import 'package:propertyhub/presentation/providers/auth_provider.dart';
import 'package:propertyhub/presentation/widgets/common/cinematic_background.dart';
import 'package:propertyhub/presentation/widgets/common/glass_container.dart';
import 'package:propertyhub/presentation/widgets/common/primary_button.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCheckingEmail = false;
  bool _emailValidAndNew = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() => _errorMessage = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _errorMessage == message) {
        setState(() => _errorMessage = null);
      }
    });
  }

  Future<void> _checkEmail() async {
    final email = _emailController.text.trim();
    final error = AppValidators.validateEmail(email);
    
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() {
      _isCheckingEmail = true;
      _errorMessage = null;
    });

    try {
      final exists = await ref.read(authNotifierProvider.notifier).checkEmailExists(email);
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
          if (exists) {
            _errorMessage = 'This email is already registered. Please sign in or use another email.';
            _emailValidAndNew = false;
          } else {
            _emailValidAndNew = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _linkAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    final passError = AppValidators.validatePassword(password);
    if (passError != null) {
      _showError(passError);
      return;
    }

    if (password != confirm) {
      _showError('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).linkEmailToAccount(
        email: email,
        password: password,
      );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account secured successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTypography.labelMedium.copyWith(color: AppColors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String bgUrl = 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=2000&q=80';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: CinematicBackground(
        imageUrl: bgUrl,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                      Text(
                        'Secure Account',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppColors.onPrimary,
                            ),
                      ),
                      const SizedBox(height: 24),
                      GlassContainer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Add Email & Password',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.onPrimary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Link an email to access your account easily from anywhere.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            _buildErrorBanner(),
                            
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email address',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              enabled: !_emailValidAndNew, 
                            ),
                            
                            const SizedBox(height: 16),
                            
                            if (!_emailValidAndNew)
                              PrimaryButton(
                                text: 'Continue',
                                isLoading: _isCheckingEmail,
                                onPressed: _checkEmail,
                              )
                            else ...[
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Create Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: 'Secure My Account',
                                isLoading: _isLoading,
                                onPressed: _linkAccount,
                              ),
                            ],
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
      ),
    );
  }
}

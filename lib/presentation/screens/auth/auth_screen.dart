import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/utils/validators.dart';
import 'package:propertyhub/presentation/providers/auth_provider.dart';
import 'package:propertyhub/presentation/widgets/cinematic_background.dart';
import 'package:propertyhub/presentation/widgets/glass_container.dart';
import 'package:propertyhub/presentation/widgets/primary_button.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _selectedRole = 1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailError = AppValidators.validateEmail(email);
    if (emailError != null) {
      _showError(emailError);
      return;
    }

    final passError = AppValidators.validatePassword(password, isLogin: true);
    if (passError != null) {
      _showError(passError);
      return;
    }

    setState(() => _errorMessage = null);
    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          email: email,
          password: password,
        );
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailError = AppValidators.validateEmail(email);
    if (emailError != null) {
      _showError(emailError);
      return;
    }

    final passError = AppValidators.validatePassword(password);
    if (passError != null) {
      _showError(passError);
      return;
    }

    setState(() => _errorMessage = null);
    await ref.read(authNotifierProvider.notifier).signUpWithEmail(
          email: email,
          password: password,
          role: _selectedRole,
        );
  }

  void _toggleFlip() {
    if (_isLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isLogin = !_isLogin);
    });
  }

  Widget _buildErrorBanner(String errorText) {
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
              errorText,
              style: AppTypography.labelMedium.copyWith(color: AppColors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons(bool isLoading) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white24)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR CONTINUE WITH', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
            ),
            const Expanded(child: Divider(color: Colors.white24)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => ref.read(authNotifierProvider.notifier).signInWithGoogle(),
                icon: const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                label: Text('Google', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.white38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => context.push('/phone-auth'),
                icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                label: Text('Phone', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.white38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm(AsyncValue<void> authState) {
    return GlassContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Discover Your\nDream Estate',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Curated luxury properties for the discerning buyer.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          if (authState.hasError) 
            _buildErrorBanner(authState.error.toString())
          else if (_errorMessage != null) 
            _buildErrorBanner(_errorMessage!),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Sign In',
            isLoading: authState.isLoading,
            onPressed: _login,
          ),
          const SizedBox(height: 16),
          _buildSocialButtons(authState.isLoading),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _toggleFlip,
              child: Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                  children: [
                    TextSpan(
                      text: 'Create one',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(AsyncValue<void> authState) {
    return GlassContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Join the Elite',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your account to get started.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = 1),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedRole == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedRole == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Buyer',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _selectedRole == 1 ? AppColors.primary : Colors.white.withValues(alpha: 0.7),
                          fontWeight: _selectedRole == 1 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = 2),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedRole == 2 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedRole == 2
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Owner / Agent',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _selectedRole == 2 ? AppColors.primary : Colors.white.withValues(alpha: 0.7),
                          fontWeight: _selectedRole == 2 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          if (authState.hasError) 
            _buildErrorBanner(authState.error.toString())
          else if (_errorMessage != null) 
            _buildErrorBanner(_errorMessage!),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Create Account',
            isLoading: authState.isLoading,
            onPressed: _register,
          ),
          const SizedBox(height: 16),
          _buildSocialButtons(authState.isLoading),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _toggleFlip,
              child: Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    const String bgUrl = 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=2000&q=80';

    return CinematicBackground(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Text(
                      'PropertyHub',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.onPrimary,
                          ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final angle = _animation.value * pi;
                        final isBack = angle > pi / 2;

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: isBack
                              ? Transform(
                                  transform: Matrix4.identity()..rotateY(pi),
                                  alignment: Alignment.center,
                                  child: _buildRegisterForm(authState),
                                )
                              : _buildLoginForm(authState),
                        );
                      },
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

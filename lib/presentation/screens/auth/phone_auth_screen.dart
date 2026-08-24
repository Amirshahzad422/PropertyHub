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

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _otpSent = false;
  String _verificationId = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
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

  void _sendOtp() async {
    FocusScope.of(context).unfocus(); 

    final phone = _phoneController.text.trim();
    final error = AppValidators.validatePhone(phone);
    
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await ref.read(authNotifierProvider.notifier).sendPhoneOTP(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
        }
      },
      verificationFailed: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
        }
      },
    );
  }

  void _verifyOtp() async {
    FocusScope.of(context).unfocus(); 

    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      _showError('Please enter a valid 6-digit OTP.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithPhone(
        verificationId: _verificationId,
        smsCode: otp,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
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
          onPressed: () {
            if (_otpSent) {
              setState(() => _otpSent = false);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: CinematicBackground(
        imageUrl: bgUrl,
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'PropertyHub',
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
                              _otpSent ? 'Verify Phone' : 'Continue with Phone',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.onPrimary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _otpSent
                                  ? 'Enter the 6-digit code sent to\n${_phoneController.text}'
                                  : 'We will send you a one-time password to verify your identity.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            _buildErrorBanner(),
                            if (!_otpSent) ...[
                              TextField(
                                controller: _phoneController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: '+1 234 567 8900',
                                  prefixIcon: Icon(Icons.phone_outlined),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: 'Send Code',
                                isLoading: _isLoading,
                                onPressed: _sendOtp,
                              ),
                            ] else ...[
                              TextField(
                                controller: _otpController,
                                decoration: const InputDecoration(
                                  hintText: '000000',
                                  prefixIcon: Icon(Icons.password_outlined),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                textAlign: TextAlign.center,
                                style: AppTypography.headlineMedium.copyWith(letterSpacing: 8, color: AppColors.primary),
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                text: 'Verify',
                                isLoading: _isLoading,
                                onPressed: _verifyOtp,
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

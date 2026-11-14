import 'package:flutter/material.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'alex@claytasks.app');
  final TextEditingController _passwordController =
      TextEditingController(text: '••••••••••••');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        widget.onLoginSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative Clay Spheres in Background
            Positioned(
              top: -40,
              left: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ClayColors.lavenderSurface.withValues(alpha: 0.55),
                  boxShadow: ClayShadows.extruded(offset: 10, blur: 20),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ClayColors.mintSurface.withValues(alpha: 0.6),
                  boxShadow: ClayShadows.extruded(offset: 8, blur: 16),
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: 10,
              child: Container(
                width: 60,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: ClayColors.blueSurface.withValues(alpha: 0.4),
                  boxShadow: ClayShadows.subtle(offset: 4, blur: 8),
                ),
              ),
            ),

            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo Container
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ClayColors.surfaceContainerLow,
                        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 2.0,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.layers_rounded,
                          size: 48,
                          color: ClayColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // App Title & Tagline
                    Text(
                      'Clay Tasks',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: ClayColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'A little progress every day.',
                      style: TextStyle(
                        fontSize: 14,
                        color: ClayColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Main Form Card
                    Container(
                      decoration: BoxDecoration(
                        color: ClayColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ClayColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClayTextField(
                            controller: _emailController,
                            hintText: 'alex@claytasks.app',
                            prefixIcon: Icons.mail_rounded,
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ClayColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClayTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 20,
                                color: ClayColors.textSecondary,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: ClayColors.primary,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Login Button
                          ClayButton(
                            label: 'Login',
                            isPrimary: true,
                            isLoading: _isLoading,
                            onPressed: _isLoading ? null : _handleLogin,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Don't have an account? Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 13,
                            color: ClayColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleLogin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: ClayColors.blueSurface,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: ClayShadows.subtle(offset: 2, blur: 5),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: ClayColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Offline & Private Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: ClayColors.mintSurface,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: ClayColors.mintShadow.withValues(alpha: 0.9),
                            offset: const Offset(2, 2),
                            blurRadius: 5,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-2, -2),
                            blurRadius: 5,
                          ),
                        ],
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.85), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.lock_rounded,
                            size: 14,
                            color: ClayColors.mintText,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '100% Offline & Private on this Device',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: ClayColors.mintText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

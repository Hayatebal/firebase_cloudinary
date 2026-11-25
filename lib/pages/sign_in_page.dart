import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _isSignUp = false;
  bool _passwordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });

    try {
      if (_isSignUp) {
        await AuthService.instance.signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await AuthService.instance.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });

    try {
      await AuthService.instance.signInWithGoogle();
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF454550),
        fontSize: 12,
        letterSpacing: 1.5,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 18, right: 14),
        child: Icon(icon, size: 31, color: const Color(0xFF55556A)),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 64, minHeight: 62),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF626082), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF626082), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC84A4A)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC84A4A)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 600 ? 38.0 : 72.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 82),
                        Container(
                          width: 112,
                          height: 112,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F1F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 68,
                            color: Color(0xFF5D4C84),
                          ),
                        ),
                        const SizedBox(height: 34),
                        Text(
                          _isSignUp ? 'Create Account!' : 'Welcome Back!',
                          style: const TextStyle(
                            color: Color(0xFF303038),
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          _isSignUp
                              ? 'Sign up to get started'
                              : 'Sign in to continue',
                          style: const TextStyle(
                            color: Color(0xFFA7A7AA),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 53),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          style: const TextStyle(
                            color: Color(0xFF454550),
                            fontSize: 12,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter your email';
                            }
                            return null;
                          },
                          decoration: _fieldDecoration(
                            hintText: 'Email',
                            icon: Icons.mail_outline,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _submitEmail(),
                          style: const TextStyle(
                            color: Color(0xFF454550),
                            fontSize: 12,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your password';
                            }
                            if (_isSignUp && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          decoration: _fieldDecoration(
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF55556A),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 62,
                          child: FilledButton(
                            onPressed: _isSigningIn ? null : _submitEmail,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F1F5),
                              foregroundColor: const Color(0xFF676482),
                              disabledBackgroundColor: const Color(0xFFF1F1F5),
                              elevation: 4,
                              shadowColor: const Color(0x33000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSigningIn
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isSignUp ? 'Register' : 'Login',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 2,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFD7D7D7),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Color(0xFFA7A7AA),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFD7D7D7),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 29),
                        SizedBox(
                          width: double.infinity,
                          height: 62,
                          child: OutlinedButton.icon(
                            onPressed: _isSigningIn ? null : _signInWithGoogle,
                            icon: const Icon(
                              Icons.login,
                              size: 27,
                              color: Color(0xFF626082),
                            ),
                            label: const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Color(0xFF626082),
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF626082),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              _isSignUp
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                              style: const TextStyle(
                                color: Color(0xFF303038),
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            InkWell(
                              onTap: _isSigningIn
                                  ? null
                                  : () {
                                      setState(() {
                                        _isSignUp = !_isSignUp;
                                        _errorMessage = null;
                                      });
                                    },
                              child: Text(
                                _isSignUp ? 'Sign in' : 'Register here',
                                style: const TextStyle(
                                  color: Color(0xFF626082),
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
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

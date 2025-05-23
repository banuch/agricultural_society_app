import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/launage_providers.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../providers/user_provider.dart';

import '../../models/user_model.dart';
import '../../utils/app_localization.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(_isLogin ? localizations.login : localizations.signUp),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildLanguageSelector(languageProvider),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(localizations),
                  const SizedBox(height: 40),
                  _buildForm(localizations),
                  const SizedBox(height: 24),
                  _buildAuthButtons(localizations),
                  const SizedBox(height: 20),
                  _buildToggleButton(localizations),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider) {
    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(languageProvider.getLanguageFlag(languageProvider.currentLocale)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (Locale locale) {
        languageProvider.changeLanguage(locale);
      },
      itemBuilder: (context) => LanguageProvider.supportedLanguages
          .map((lang) => PopupMenuItem<Locale>(
        value: lang['locale'],
        child: Row(
          children: [
            Text(lang['flag']),
            const SizedBox(width: 8),
            Text(lang['nativeName']),
          ],
        ),
      ))
          .toList(),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.agriculture,
            size: 60,
            color: Colors.green.shade600,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          localizations.appName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? localizations.welcome : 'Create your account',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AppLocalizations localizations) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(localizations),
          const SizedBox(height: 16),
          _buildPasswordField(localizations),
          if (_isLogin) ...[
            const SizedBox(height: 12),
            _buildForgotPasswordButton(localizations),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField(AppLocalizations localizations) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: localizations.email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.pleaseEnterEmail;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return localizations.pleaseEnterValidEmail;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(AppLocalizations localizations) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: localizations.password,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.pleaseEnterPassword;
        }
        if (value.length < 6) {
          return localizations.passwordTooShort;
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordButton(AppLocalizations localizations) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(localizations.forgotPassword),
      ),
    );
  }

  Widget _buildAuthButtons(AppLocalizations localizations) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailAuth,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Text(
              _isLogin ? localizations.login : localizations.signUp,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleGoogleAuth,
            icon: Image.asset('assets/images/google_logo.png', height: 20, width: 20),
            label: Text(localizations.continueWithGoogle),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(AppLocalizations localizations) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
          _formKey.currentState?.reset();
        });
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey.shade600),
          children: [
            TextSpan(
              text: _isLogin
                  ? '${localizations.dontHaveAccount} '
                  : '${localizations.alreadyHaveAccount} ',
            ),
            TextSpan(
              text: _isLogin ? localizations.signUp : localizations.login,
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailAuth() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final userService = Provider.of<UserService>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        if (_isLogin) {
          await authService.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await authService.signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }

        final currentUser = authService.currentUser;
        if (currentUser != null) {
          if (!_isLogin) {
            // Create new user profile
            final newUser = UserModel(
              uid: currentUser.uid,
              name: currentUser.displayName ?? '',
              email: currentUser.email ?? '',
              role: UserRole.buyer,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await userService.createOrUpdateUser(newUser);
            userProvider.setUser(newUser);
          } else {
            // Load existing user
            final user = await userService.getUserById(currentUser.uid);
            userProvider.setUser(user);
          }

          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleAuth() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final result = await authService.signInWithGoogle();
      if (result != null) {
        final currentUser = result.user!;

        // Check if user exists
        final existingUser = await userService.getUserById(currentUser.uid);

        if (existingUser == null) {
          // Create new user profile
          final newUser = UserModel(
            uid: currentUser.uid,
            name: currentUser.displayName ?? '',
            email: currentUser.email ?? '',
            role: UserRole.buyer,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await userService.createOrUpdateUser(newUser);
          userProvider.setUser(newUser);
        } else {
          userProvider.setUser(existingUser);
        }

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email address first');
      return;
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.resetPassword(_emailController.text.trim());
      _showSuccessDialog('Password reset email sent. Please check your inbox.');
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
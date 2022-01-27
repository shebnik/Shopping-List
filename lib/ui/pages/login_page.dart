import 'package:flutter/material.dart';
import 'package:shoppinglist/models/user_auth.dart';
import 'package:shoppinglist/services/app_utils.dart';
import 'package:shoppinglist/services/auth_service.dart';
import 'package:shoppinglist/services/validators.dart';
import 'package:shoppinglist/ui/widgets/app_elevated_button.dart';
import 'package:shoppinglist/ui/widgets/app_text_button.dart';
import 'package:shoppinglist/ui/widgets/app_text_field.dart';
import 'package:shoppinglist/ui/widgets/auth_widget.dart';
import 'package:shoppinglist/ui/widgets/loading.dart';

enum CurrentPage { login, createAccount }

class LoginPage extends StatefulWidget {
  static const routeName = '/signin';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CurrentPage _currentPage = CurrentPage.createAccount;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _isEmailError = ValueNotifier(false);
  final ValueNotifier<bool> _isPasswordError = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  UserAuth? getEmailPassword() {
    String email = _emailController.value.text.trim().toLowerCase();
    String password = _passwordController.value.text;

    _isEmailError.value = Validators.validateEmail(email) ? false : true;
    if (_isEmailError.value) return null;
    _isPasswordError.value = Validators.validatePassword(email) ? false : true;
    if (_isPasswordError.value) return null;

    FocusScope.of(context).unfocus();
    return UserAuth(email: email, password: password);
  }

  Future<void> _createAccount() async {
    UserAuth? userAuth = getEmailPassword();
    if (userAuth == null) return;

    _isLoading.value = true;
    final errorText = await AuthService.createAccount(userAuth);
    if (errorText != null) {
      AppUtils.showSnackBar(context, errorText);
    }
    _isLoading.value = false;
  }

  Future<void> _login() async {
    UserAuth? userAuth = getEmailPassword();
    if (userAuth == null) return;

    _isLoading.value = true;
    final errorText = await AuthService.login(userAuth);
    if (errorText != null) {
      AppUtils.showSnackBar(context, errorText);
    }
    _isLoading.value = false;
  }

  Future<void> _googleSignIn() async {
    _isLoading.value = true;
    await AuthService.signInGoogle(context);
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthWidget(
          child: loginColumn(),
        ),
      ),
    );
  }

  Widget loginColumn() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _currentPage == CurrentPage.createAccount
                  ? 'Create account'
                  : 'Log in',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isEmailError,
            builder: (context, value, child) => AppTextField(
              controller: _emailController,
              label: 'Email',
              errorText: 'Email is wrong',
              showError: value,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isPasswordError,
            builder: (context, value, child) => AppTextField(
              controller: _passwordController,
              label: 'Password',
              errorText: 'Password is wrong',
              showError: value,
              isPassword: true,
            ),
          ),
          const SizedBox(height: 16),
          loginButtons(),
        ],
      ),
    );
  }

  Widget loginButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, value, child) => Column(
        children: [
          createAccountLoginButtons(value),
          const SizedBox(height: 16),
          const Text('or'),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: AppElevatedButton(
              text: 'Sign in with Google',
              onPressed: _googleSignIn,
              isDisabled: value,
            ),
          ),
          const SizedBox(height: 16),
          if (value) const LoadingIndicator(),
        ],
      ),
    );
  }

  Widget createAccountLoginButtons(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: AppTextButton(
            text:
                _currentPage == CurrentPage.login ? 'Create account' : 'Log in',
            onPressed: () => setState(() {
              _currentPage = _currentPage == CurrentPage.createAccount
                  ? CurrentPage.login
                  : CurrentPage.createAccount;
            }),
            isDisabled: isLoading,
          ),
        ),
        const SizedBox(width: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: AppElevatedButton(
            text: _currentPage == CurrentPage.createAccount
                ? 'Create account'
                : 'Log in',
            onPressed: _currentPage == CurrentPage.createAccount
                ? _createAccount
                : _login,
            isDisabled: isLoading,
          ),
        ),
      ],
    );
  }
}

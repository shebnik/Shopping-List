class Validators {
  static bool validateEmail(String email) =>
      email.length > 4 && email.contains('@') ? true : false;

  static bool validatePassword(String password) =>
      password.length > 6 ? true : false;
}

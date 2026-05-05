class Validators {
  Validators._();

  static final _nameRegex = RegExp(r'^[A-Za-z\s]+$');
  static final _usernameRegex = RegExp(r'^[a-z0-9._]+$');
  static final _emailRegex =
      RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[A-Za-z]{2,}$');
  static final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>_\-+=/\\\[\]~`;])[A-Za-z\d!@#\$%^&*(),.?":{}|<>_\-+=/\\\[\]~`;]{8,}$',
  );

  static String? username(String? value) {
    final v = value?.trim().toLowerCase() ?? '';
    if (v.isEmpty) return 'Username is required';
    if (v.length < 3) return 'At least 3 characters';
    if (v.length > 24) return 'At most 24 characters';
    if (!_usernameRegex.hasMatch(v)) {
      return 'Lowercase letters, numbers, "." or "_" only';
    }
    return null;
  }

  static String? otp(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter the 6-digit code';
    if (v.length != 6 || int.tryParse(v) == null) {
      return 'Code must be 6 digits';
    }
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 2) return 'Name is too short';
    if (!_nameRegex.hasMatch(v)) {
      return 'Only letters and spaces allowed';
    }
    return null;
  }

  static String? age(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Age is required';
    final n = int.tryParse(v);
    if (n == null) return 'Enter a valid number';
    if (n < 13) return 'You must be at least 13';
    if (n > 120) return 'Enter a realistic age';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min 8 characters';
    if (!_passwordRegex.hasMatch(v)) {
      return 'Need 1 uppercase, 1 number & 1 special character';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    return null;
  }

  static String? preferences(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Tell us your travel vibe';
    return null;
  }
}

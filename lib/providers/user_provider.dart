import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Check if user is authenticated
  bool get isAuthenticated => _user != null;

  // Check if user profile is complete
  bool get isProfileComplete {
    if (_user == null) return false;
    return _user!.name.isNotEmpty &&
        _user!.phoneNumber != null &&
        _user!.phoneNumber!.isNotEmpty &&
        _user!.location != null &&
        _user!.location!.isNotEmpty;
  }

  // Set user data
  void setUser(UserModel? user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  // Clear user data (logout)
  void clearUser() {
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update user data locally (before syncing with server)
  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    _error = null;
    notifyListeners();
  }

  // Update specific user fields
  void updateUserField({
    String? name,
    String? phoneNumber,
    String? location,
    String? pincode,
    double? latitude,
    double? longitude,
    UserRole? role,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        location: location,
        pincode: pincode,
        latitude: latitude,
        longitude: longitude,
        role: role,
      );
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get user role display name
  String getRoleDisplayName() {
    if (_user == null) return 'Not set';
    switch (_user!.role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.both:
        return 'Both Buyer & Seller';
    }
  }

  // Check if user is buyer
  bool get isBuyer => _user?.role == UserRole.buyer || _user?.role == UserRole.both;

  // Check if user is seller
  bool get isSeller => _user?.role == UserRole.seller || _user?.role == UserRole.both;

  // Get user initials for avatar
  String getUserInitials() {
    if (_user == null || _user!.name.isEmpty) return 'U';
    List<String> names = _user!.name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return _user!.name[0].toUpperCase();
  }

  // Get formatted location
  String getFormattedLocation() {
    if (_user?.location != null) {
      return _user!.location!;
    }
    if (_user?.pincode != null) {
      return 'Pincode: ${_user!.pincode}';
    }
    return 'Location not set';
  }

  // Get formatted phone number
  String getFormattedPhoneNumber() {
    if (_user?.phoneNumber != null && _user!.phoneNumber!.isNotEmpty) {
      String phone = _user!.phoneNumber!;
      if (phone.length == 10) {
        return '${phone.substring(0, 5)} ${phone.substring(5)}';
      }
      return phone;
    }
    return 'Not provided';
  }
}
import 'package:flutter_test/flutter_test.dart';
import 'package:reservrec/src/user_functions.dart';

void main() {
  group('Username', () {
    test('Validating Short Username', () {
      expect(verifyUsername("t"), false);
    });

    test('Validating Long Username', () {
      expect(verifyUsername("usernameusername"), false);
    });

    test('Empty Name', () {
      expect(verifyUsername(""), false);
    });

    test('Special Character', () {
      expect(verifyUsername("😀user"), false);
    });

    test('Numbers', () {
      expect(verifyUsername("123456"), true);
    });
  });

  group('Email', () {
    test('Temp Test', () {
      expect(validEmail("f@crimson.ua.edu"), true);
    });
  });

  group('Password', () {
    test('Confirm Passwords Are Not Same', () {
      expect(verifyPassword("password", "password1"), false);
    });

    test('No uppercase', () {
      expect(verifyPassword("password1", "password1"), false);
    });

    test('No lowercase', () {
      expect(verifyPassword("PASSWORD1", "PASSWORD1"), false);
    });

    test('No number', () {
      expect(verifyPassword("Password", "Password"), false);
    });

    test('Too short', () {
      expect(verifyPassword("Pass1", "Pass1"), false);
    });

    test('Working Password', () {
      expect(verifyPassword("Password1", "Password1"), true);
    });
  });
}
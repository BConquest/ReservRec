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
      //need await functionality
      expect(validEmail("f@crimson.ua.edu"), true);
    });
  });

  group('Password', () {
    test('Does Not Match', () {
      expect(validPassword("Password123", "Password12"), false);
    });

    test('No Number', () {
      expect(validPassword("Passwords", "Passwords"), false);
    });

    test('No Uppercase', () {
      expect(validPassword("password123", "password123"), false);
    });

    test('No Lowercase', () {
      expect(validPassword("PASSWORD123", "PASSWORD123"), false);
    });

    test('Random Symbols', () {
      expect(validPassword("!@#^&*__()", "!@#^&*__()"), false);
    });

    test('Valid Password', () {
      expect(validPassword("Password123", "Password123"), true);
    });
  });
}
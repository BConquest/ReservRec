import 'package:flutter_test/flutter_test.dart';
import 'package:reservrec/src/user_functions.dart';
import 'package:reservrec/src/verify_location.dart';

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
    test('Asynchronous Check', () {
      //throws exception because nothing was ever awaited
      expect(validEmail("anything@crimson.ua.edu"), throwsException);
    });

    // need to use firebase emulator

    /*
    test('Crimson Email', () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      expect(await validEmail("anything@crimson.ua.edu"), true);
    });

    test('Different UA Email', () async {
      expect(await validEmail("anything@cs.ua.edu"), true);
    });

    test('Indiana', () async{
      expect(await validEmail("anything@iowa.edu"), true);
    });

    test('Anything else is false', () async{
      expect(validEmail("anything@gmail.com"), false);
    });*/
  });

  group('Password Regex', () {
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

  group('Distance', () {
    test('Zero distance', () {
      expect(calcDistance(0,0,0,0), 0);
    });

    test('Same position', () {
      expect(calcDistance(10,10,10,10), 0);
    });

    test('Random coordinates 1', () {
      expect(calcDistance(13.4,13,12,111), 6595.002306580232);
    });

    test('Random coordinates 2', () {
      expect(calcDistance(-10,3,103,14), 6182.122582136241);
    });

    test('Out of bounds parameters', () {
      expect(() => calcDistance(181,-1000,1000,0), throwsAssertionError);
    });
  });
}
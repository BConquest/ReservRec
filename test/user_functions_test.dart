import 'package:flutter_test/flutter_test.dart';
import 'package:reservrec/src/new_post.dart';
import 'package:reservrec/src/user_functions.dart';
import 'package:reservrec/src/verify_location.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/hashing.dart';

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

  group('Async vs. Sync', () {
    test('Asynchronous Check 1', () {
      //throws exception because nothing was ever awaited
      expect(validEmail("anything@crimson.ua.edu"), throwsException);
    });

    test('Asynchronous Check 2', () {
      //throws exception because nothing was ever awaited
      expect(getDocumentID("anything"), throwsException);
    });
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

  group('DateTime Test', (){
    test('Date 1', () async {
      var millennium = DateTime(2000, 1, 1);
      expect(await getTimeDispString(millennium), "1/1/2000 - 00:00 AM");
    });

    test('Date 2', () async {
      var future = DateTime(2020, 12, 25);
      expect(await getTimeDispString(future), "12/25/2020 - 00:00 AM");
    });

    test('Date 3', () async {
      var overflowWorks = DateTime(3000, 20, 10);
      expect(await getTimeDispString(overflowWorks), "8/10/3001 - 00:00 AM");
    });
  });

  group('Testing Assertions', ()
  {
    test('Trying DateTime', () async {
      var noWork = DateTime(-10, 20, 30);
      try{
        await getTimeDispString(noWork);
        expect(await getTimeDispString(noWork), throwsAssertionError);
      } catch(e) {
        expect(e, isInstanceOf<AssertionError>());
      }
    });
  });

  group('User Testing', ()
  {
    UserC myUser = new UserC("id");

    test('Verify Email', () {
      myUser.setVerified(true);
      assert(myUser.verified == true);
    });

    test('Other Setter Methods', (){
      myUser.setSchool("University of Alabama");
      myUser.setPassword("Password");
      assert(myUser.userPassword == "Password");
      assert(myUser.school == "University of Alabama");
      expect(myUser.school, isInstanceOf<String>());
    });
  });

  group('Hashing Password', (){
    //all values were tested with an independent SHA256 string checker

    test('Null', (){
      expect(Sha256(""), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"); //this is the value of the null string
    });

    test('hello', (){
      expect(Sha256("hello"), "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824");
    });

    test('hashing a hash value', (){
      expect(Sha256(Sha256("hello")), "d7914fe546b684688bb95f4f888a92dfc680603a75f23eb823658031fff766d9");
    });
  });
}

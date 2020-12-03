import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reservrec/src/new_post.dart';
import 'package:reservrec/src/user_functions.dart';
import 'package:reservrec/src/verify_location.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/models/post.dart';
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
    UserC myUser = UserC("id");

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

    test('Yet again', (){
      myUser.setBanned(true);
      myUser.setGamesPlayed(4);
      myUser.setSportsmanshipReport(0);
      myUser.setPunctualityReport(1);
      assert(myUser.banned);
      assert(myUser.gamesPlayed == 4);
      assert(myUser.sportsmanshipReport == 0);
      assert(myUser.punctualityReport == 1);
    });
  });

  group('Hashing Password', (){
    //all values were tested with an independent SHA256 string checker

    test('Empty String', (){
      expect(Sha256(""), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"); //this is the value of the null string
    });

    test('hello', (){
      expect(Sha256("hello"), "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824");
    });

    test('hashing a hash value', (){
      expect(Sha256(Sha256("hello")), "d7914fe546b684688bb95f4f888a92dfc680603a75f23eb823658031fff766d9");
    });
  });
  group('Converting Users to and from json', () {
    test('Converting User to json', () {
      UserC testUser = UserC('testid', userUsername: 'foo', userPassword: 'bar', userEmail: 'email@crimson.ua.edu', verified: true, school: 'University of Alabama', photoURL: 'https://i.imgur.com/DfGZewB.png');
      var testJson = testUser.toJson();
      expect(testJson['user_id'], 'testid');
      expect(testJson['user_username'], 'foo');
      expect(testJson['user_password'], 'bar');
      expect(testJson['user_email'], 'email@crimson.ua.edu');
      expect(testJson['verified'], true);
      expect(testJson['school'], 'University of Alabama');
      expect(testJson['photoURL'], 'https://i.imgur.com/DfGZewB.png');
    });
    test('Converting User From json', () {
      var testMap = Map();
      testMap['user_id'] = 'testid';
      testMap['user_username'] = 'foo';
      testMap['user_password'] = 'bar';
      testMap['user_email'] = 'email@crimson.ua.edu';
      testMap['verified'] = true;
      testMap['school'] = 'University of Alabama';
      testMap['photoURL'] = 'https://i.imgur.com/DfGZewB.png';
      UserC testUser = UserC.fromJson(testMap);
      expect(testUser.userId, 'testid');
      expect(testUser.userUsername, 'foo');
      expect(testUser.userPassword, 'bar');
      expect(testUser.userEmail, 'email@crimson.ua.edu');
      expect(testUser.verified, true);
      expect(testUser.school, 'University of Alabama');
      expect(testUser.photoURL, 'https://i.imgur.com/DfGZewB.png');
    });
  });
  group('Converting Post to and from json', () {
    test('Converting Post to json', () {
      DateTime testTime =  DateTime.now();
      Post testPost = Post('testUserId', 0, postDescription: 'desc', postTimePosted: testTime, postTimeSet: testTime, postSport: 'sportball', postLocation: 'testLoc', school: 'University of Alabama', maxPeople: 20, minPeople: 5, curPeople: 6);
      var testJson = testPost.toJson();
      expect(testJson["user_id"], 'testUserId');
      expect(testJson["post_id"], 0);
      expect(testJson["description"], 'desc');
      expect(testJson["time_posted"], testTime);
      expect(testJson["time_set"], testTime);
      expect(testJson["sport"], 'sportball');
      expect(testJson["location"], 'testLoc');
      expect(testJson["school"], 'University of Alabama');
      expect(testJson["max_people"], 20);
      expect(testJson["min_people"], 5);
      expect(testJson["cur_people"], 6);
    });
    test('Converting Post From json', () {
      var testMap = Map();
      Timestamp testTime =  Timestamp.now();
      testMap["user_id"] = 'testUserId';
      testMap["post_id"] = 0;
      testMap["description"] = 'desc';
      testMap["time_posted"] = testTime;
      testMap["time_set"] = testTime;
      testMap["sport"] ='sportball';
      testMap["location"] = 'testLoc';
      testMap["school"] = 'University of Alabama';
      testMap["max_people"] = 20;
      testMap["min_people"] = 5;
      testMap["cur_people"] = 6;
      Post testPost = Post.fromJson(testMap);
      expect(testPost.postUserId, 'testUserId');
      expect(testPost.postId, 0);
      expect(testPost.postDescription, 'desc');
      expect(testPost.postTimePosted, testTime.toDate());
      expect(testPost.postTimeSet, testTime.toDate());
      expect(testPost.postSport, 'sportball');
      expect(testPost.postLocation, 'testLoc');
      expect(testPost.school, 'University of Alabama');
      expect(testPost.maxPeople, 20);
      expect(testPost.minPeople, 5);
      expect(testPost.curPeople, 6);
    });
  });

  group('Post Testing', ()
  {
    Post myPost = Post("uid", 0);

    test('Verify Email', () {
      myPost.setUserId("newuid");
      assert(myPost.postUserId == "newuid");
    });

    test('Other Setter Methods', (){
      myPost.setMaxPeople(10);
      myPost.setMinPeople(2);
      assert(myPost.maxPeople == 10);
      assert(myPost.minPeople == 2);
      expect(myPost.minPeople, isInstanceOf<int>());
    });
    test('Even More Setters', (){
      myPost.setCurPeople(1);
      myPost.setLocation("University of Alabama");
      myPost.setDescription("Football with friends");
      assert(myPost.postDescription == "Football with friends");
      assert(myPost.curPeople == 1);
      assert(myPost.postLocation == "University of Alabama");
    });
  });
}

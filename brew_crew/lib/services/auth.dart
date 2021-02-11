import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Authservice {

// create user object based on FirebaseUser
User _userFromFirebaseUser(FirebaseUser user){
  return user != null ? User(uid: user.uid) : null;
}

// auth change User stream
Stream<User> get user {
  return _auth.onAuthStateChanged
  .map(_userFromFirebaseUser);
}
// sign in anon
final FirebaseAuth _auth = FirebaseAuth.instance;

Future signinAnon() async{

  try{
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);

  }
  catch(e){
    print(e.toString());
    return null;

  }
}
  // sign in with email & password
  Future signInWithEmailPass(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with email & password
  Future regWithEmailPass(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'New Member', 100);
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;

    }
  }

}
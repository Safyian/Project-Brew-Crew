import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

final String uid;
DatabaseService({this.uid});

  // collection reference
  final brewCollection = Firestore.instance.collection('brews');

  Future updateUserData(String sugar, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugar,
      'name': name,
      'strength': strength
    });

  }

  // Brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Brew(
        name: doc.data['name'] ?? '',
        sugars: doc.data['sugars'] ?? '0',
        strenght: doc.data['strength'] ?? 0,

      );
    }).toList();
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength']
       );
  }


// get brew stream
Stream<List<Brew>> get brews {
  return brewCollection.snapshots()
  .map(_brewListFromSnapshot);
}

//get user doc stream
Stream<UserData> get userData{
  return brewCollection.document(uid).snapshots()
  .map(_userDataFromSnapshot);
}

}
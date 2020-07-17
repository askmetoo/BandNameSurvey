import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
 final String name;
 final int votes;
 final String image;
 final String shortDescription;
 final String wallPicture;
 final List<dynamic> photos;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference}) :
       name = map.containsKey('name') ? map['name'] : '',
       votes = map.containsKey('votes') ? map['votes'] : 0,
       image = map.containsKey('image') ? map['image'] : 'https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg',
       shortDescription = map.containsKey('shortDescription') ? map['shortDescription'] : '',
       photos = map.containsKey('photos') ? map['photos'] : [],
       wallPicture = map.containsKey('wallPicture') ? map['wallPicture'] : '';


 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes>";
}

import 'package:band_name_survey/models/records.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BandDetailScreen extends StatefulWidget
{
  static final String route = '/bandDetailScreen';
  final DocumentSnapshot documentSnapshot;

  BandDetailScreen({@required this.documentSnapshot});

  _BandDetailScreenState createState() => _BandDetailScreenState();
} 



class _BandDetailScreenState extends State<BandDetailScreen>
{
  Record record;
  final bandDatabaseReference = Firestore.instance;

  _getSnapShotLenght(DocumentSnapshot data, Record record)
  {
    var newImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT1Q5Pqodm9s1akUfC-6uQIKiFAGVyXutbCxt_UxQvaXnKqTE9s';

    // print(data.data);
    // print('${data.data['photos']}');
    //Firestore.instance.collection('BandNames').document(data.documentID).updateData({'photos' : {0,'http://google.com'}}).then((value) => print('Success')).catchError((error)=>print('Error: $error'));
    
    List<dynamic> newPhotosList = List<dynamic>();
    newPhotosList.add(newImage);
    record.photos.forEach((element) {newPhotosList.add(element);});
    Firestore.instance.collection('BandNames').document(data.documentID)
    .updateData({
      'photos': newPhotosList,
    })
    .then((value) => print('Success'))
    .catchError((error) => print('Error: $error'));

    // print('Inside getSnapshot length');
    // var snapshots = Firestore.instance.collection('BandNames').getDocuments().then((QuerySnapshot snapshot) {
    //   snapshot.documents.forEach((element) {
    //     if(element.documentID == data.documentID)
    //     {
    //       Firestore.instance.collection('BandNames').document(element.documentID).get()
    //     }
    //   });
    // });
    // var documents =  await snapshots.getDocuments();
    // print(documents.documents.length);
    // for(var document in documents.documents)
    // {
    //   print(document.data.values);
    // }
  }

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Band Detail')),
      body: StreamBuilder<DocumentSnapshot> (
        stream: widget.documentSnapshot.reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)
        {
          if(!snapshot.hasData)
          {
            return LinearProgressIndicator();
          }
          record = Record.fromSnapshot(snapshot.data);
          
          return ListView(
            children: <Widget>[
              _HeaderSection(record: record),
              _TitleSection(record: record),
              _CarouselPhotos(record: record,),
              FlatButton(
                 onPressed:() => _getSnapShotLenght(snapshot.data,record),
                //onPressed: (){print('OnPressed clicked');},
                child: CircleAvatar(child: Icon(Icons.add_a_photo),),
              ),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    record.shortDescription,
                  )
                )
              )
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bandDatabaseReference.runTransaction((transaction) async {
                  final freshSnapshot = await transaction.get(record.reference);
                  final fresh = Record.fromSnapshot(freshSnapshot);
                  await transaction
                  .update(record.reference, {'votes': fresh.votes + 1});
                  }),
        child: Icon(Icons.thumb_up),
        backgroundColor: Colors.blue,
        tooltip: 'Vote',
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget
{
  final Record record;
  _HeaderSection({@required this.record});

  Widget build(BuildContext context)
  {
    final width = MediaQuery.of(context).size.width;
    var image = record.image?? 'https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg';
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(record.wallPicture, fit: BoxFit.cover, width: 1000.0,),
        Container(
          width: width,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Padding(
            padding: EdgeInsets.only(top:20.0, bottom: 20.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(image),
              ),
              title: Text(
                record.name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _TitleSection extends StatelessWidget
{
  final Record record;

  _TitleSection({@required this.record});

  Widget build(BuildContext context)
  {
    Color color = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  record.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.people,
            color: color,
          ),
          Text('${record.votes} votes')
        ],
      ),
    );
  }
}

class _CarouselPhotos extends StatelessWidget
{
  final Record record;

  _CarouselPhotos({@required this.record});

  Widget build(BuildContext context)
  {
    if(record.photos.length > 0)
    {
      print("Have photos");
      Color color = Theme.of(context).primaryColor;
      return CarouselSlider(
        items: record.photos.map((image){
          return Builder(
            builder: (BuildContext context){
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: color),
                child: Image.network(image, fit: BoxFit.cover, width: 1000.0,),
              );
            },
          );
        }).toList(),
        autoPlay: true,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        pauseAutoPlayOnTouch: Duration(seconds: 3),
        viewportFraction: 0.9,
      );
    }
    else
    {
      print("Don't have any photos");
    }
    return Container(width: 0, height: 0,);
  }
}
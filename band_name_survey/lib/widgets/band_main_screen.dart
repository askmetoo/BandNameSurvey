import 'package:band_name_survey/models/records.dart';
import 'package:band_name_survey/widgets/register_band_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'band_detail.dart';

class BandDetailArguments
{
  DocumentSnapshot documentSnapshot;

  BandDetailArguments({@required this.documentSnapshot});
}

class BandMainScreen extends StatefulWidget
{
  static final route = '/bandMainScreen';

  _BandMainScreenState createState() => _BandMainScreenState();

}

class _BandMainScreenState extends State<BandMainScreen>
{
  final bandDatabaseReference = Firestore.instance;

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Band Name Votes')),
      body: _BuildBandNames(bandDatabaseReference: bandDatabaseReference,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, RegisterBand.route);
        },
      ),
    );
  }
}

class _BuildBandNames extends StatelessWidget
{
  final Firestore bandDatabaseReference;

  _BuildBandNames({@required this.bandDatabaseReference});

  Widget build(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>(
      stream: bandDatabaseReference.collection('BandNames').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();

        return _buildBandList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildBandList(BuildContext context, List<DocumentSnapshot> snapshot) {
    
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) 
  {
   
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          leading:
          record.image != null && record.image.isNotEmpty?
            CircleAvatar(backgroundImage: NetworkImage(record.image),) 
            : CircleAvatar(backgroundImage: NetworkImage('https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg'),) ,
          trailing: Text(record.votes.toString()),
          onTap: (){
            Navigator.pushNamed(context, BandDetailScreen.route, arguments: BandDetailArguments(documentSnapshot: data));
          },
        ),
      ),
    );
  }
}
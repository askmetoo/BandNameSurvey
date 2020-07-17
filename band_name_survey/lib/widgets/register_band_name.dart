
import 'package:band_name_survey/models/forms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'band_main_screen.dart';

class RegisterBand extends StatefulWidget
{
  static final String route = "/registerBand";
  _RegisterBandState createState() => _RegisterBandState();
}

class _RegisterBandState extends State<RegisterBand>
{
  final databaseReference = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  RegisterFormData _registerData = RegisterFormData();
  BuildContext _scaffoldContext;

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Band'),
      ),
      body: Builder(
        builder: (context)
        {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                    onSaved: (value) => _registerData.name = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Image',
                    ),
                    onSaved: (value) => _registerData.image = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Short Description',
                    ),
                    onSaved: (value) => _registerData.shortDescription = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Wall picture',
                    ),
                    onSaved: (value) => _registerData.wallPicture = value,
                  ),
                  _buildSubmitBtn(),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  void _handleSuccess(data)
  {
    Navigator
        .pushNamedAndRemoveUntil(context, '/', 
                                (Route<dynamic> route) => false, 
                                arguments: BandMainScreen()
                                );
  }

  void _handleError(response)
  {
    Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text(response['errors']['message'])
      ));
  }

  void _register() async
  {
    databaseReference.collection('BandNames').add({'name': _registerData.name, 'votes': 0, 'image': _registerData.image})
      .then(_handleSuccess)
      .catchError(_handleError);
  }

  void _submit()
  {
    final formKey = _formKey.currentState;
    if(formKey.validate())
    {
      formKey.save();
      _register();
    }
    else
    {
      setState(()
      {
        _autoValidate = true;
      });
    }
  }

  Widget _buildSubmitBtn() {
    return Container(
      alignment: Alignment(-1.0, 0.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: const Text('Submit'),
        onPressed: _submit,
      )
    );
  }

}
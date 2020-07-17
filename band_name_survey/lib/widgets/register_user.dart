

import 'package:band_name_survey/models/arguments.dart';
import 'package:band_name_survey/models/forms.dart';
import 'package:band_name_survey/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  //final AuthApiService auth = AuthApiService();

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 2. Create autovalidate
  bool _autoValidate = false;
  // 3. Create instance of RegisterFormData
  final RegisterUserFormData _registerData = RegisterUserFormData();
  // 4. Create Register function and print all of the data

  BuildContext _scaffoldContext;

  void _handleSuccess(data)
  {
    Navigator
        .pushNamedAndRemoveUntil(context, '/', 
                                (Route<dynamic> route) => false, 
                                arguments: LoginScreenArguments('You have been successfully registered. Feel free to login now')
                                );
  }

  //If email already exists, we will get 'errmsg' as the key in the response
  //For other errors we get 'message' as the key in the response
  void _handleError(response)
  {
    Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text(response['errors']['message'])
      ));
  }

  void _register() async
  {
    try{
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _registerData.email, password: _registerData.password);
      _handleSuccess(result);
      print('Register with user id: ${result.user.uid}');
    }catch(e)
    {
      _handleError(e);
      print('Error while registering: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register')
      ),
      body: Builder(
        builder: (context) {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              // 5. Form Key
              key:_formKey,
              autovalidate: _autoValidate,
              child: ListView(
                children: [
                  _buildTitle(),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                    ),
                    validator: composeValidators('email', [requiredValidator,emailValidator]),
                    onSaved: (value) => _registerData.email = value,
                    keyboardType: TextInputType.emailAddress
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: composeValidators('password', [requiredValidator]),
                    onSaved: (value) => _registerData.password = value,
                    obscureText: true,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                      hintText: 'Password Confirmation',
                    ),
                    validator: composeValidators('password confirmation', [requiredValidator]),
                    onSaved: (value) => _registerData.passwordConfirmation = value,
                    obscureText: true,
                  ),
                  _buildLinksSection(),
                  _buildSubmitBtn()
                ],
              ),
            )
          );
        }
      )
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
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

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
               Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

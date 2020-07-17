import 'package:band_name_survey/blocs/auth_bloc/auth_bloc.dart';
import 'package:band_name_survey/blocs/auth_bloc/events.dart';
import 'package:band_name_survey/blocs/bloc_provider.dart';
import 'package:band_name_survey/models/forms.dart';
import 'package:band_name_survey/utils/validators.dart';
import 'package:band_name_survey/widgets/register_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget
{
    final String message;
    static final String route = '/login';
    //final AuthApiService authApi = AuthApiService();
    _LoginScreenState createState() => _LoginScreenState();

    LoginScreen({this.message});
}

class _LoginScreenState extends State<LoginScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();

  AuthBloc _authBloc;

  final LoginFormData _loginData = LoginFormData();

  bool _autoValidate = false;
  BuildContext _scaffoldContext;

  @override
  initState()
  {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForMessage());
    super.initState();
  }

  void _checkForMessage()
  {
    // Future.delayed(Duration(), (){
      if(widget.message !=null && widget.message.isNotEmpty)
      {
        Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
          content: Text(widget.message)
        ));
      }
  }
    //});
    
  // }

  // _login()
  // {
  //   _authBloc.dispatch(InitLogging());
  //   widget.authApi.login(_loginData).then((data)
  //   {
  //     _authBloc.dispatch(LoggedIn());
  //   }).catchError((response)
  //   {
  //      _authBloc.dispatch(LoggedOut(message: response['errors']['message']));
  //   });
  // }

  // _submit()
  // {
  //   final formKey = _formKey.currentState;

  //   if(formKey.validate())
  //   {
  //     formKey.save();
  //     _login();
  //   }
  //   else
  //   {
  //     setState(() {
  //      _autoValidate = true; 
  //     });
  //   }
  // }

  void validateAndSubmit() async{
    final formKey = _formKey.currentState;
    if(formKey.validate())
    {
      formKey.save();
      try{
          _authBloc.dispatch(InitLogging());
          var result =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _loginData.email, password: _loginData.password);
          print('authBloc: $_authBloc');
          _authBloc.dispatch(LoggedIn());
          print('${result.user.uid}');
      }catch(e)
      {
        _authBloc.dispatch(LoggedOut(message: e.message));
        print('Error: $e');
      }
    }
  }

  Widget build(BuildContext context)
  {
    return Scaffold(
      body:  Builder(
        builder: (context)
        {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate ,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Login And Explore',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  TextFormField(
                    key: _emailKey,
                    style: Theme.of(context).textTheme.headline,
                    onSaved: (value) => _loginData.email = value,
                    validator: composeValidators(
                                  'email',
                                  [requiredValidator, minLengthValidator, emailValidator]),
                    decoration: InputDecoration(
                      hintText: 'Email Address'
                    ),
                    keyboardType: TextInputType.emailAddress
                  ),
                  TextFormField(
                    key: _passwordKey,
                    obscureText: true,
                    style: Theme.of(context).textTheme.headline,
                    onSaved: (value) => _loginData.password = value,
                    validator: composeValidators(
                                  'password',
                                  [requiredValidator, minLengthValidator]),
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  _buildLinks(),
                  Container(
                    alignment: Alignment(-1.0, 0.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: const Text('Submit'),
                      //onPressed: _submit,
                      onPressed: validateAndSubmit,
                    )
                  )
                ],
              ),
            )
          );
        },
      ),
      
      appBar: AppBar(
        title: Text('Login'),
      ),
    );
  }

  Widget _buildLinks()
  {
    return Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RegisterScreen.route),
                  child: Text(
                    'Not registered yet? Register now!',
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
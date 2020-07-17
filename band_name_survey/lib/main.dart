
import 'package:band_name_survey/blocs/auth_bloc/auth_bloc.dart';
import 'package:band_name_survey/blocs/auth_bloc/events.dart';
import 'package:band_name_survey/blocs/auth_bloc/states.dart';
import 'package:band_name_survey/blocs/bloc_provider.dart';
import 'package:band_name_survey/models/arguments.dart';
import 'package:band_name_survey/widgets/band_main_screen.dart';
import 'package:band_name_survey/widgets/login_screen.dart';
import 'package:band_name_survey/widgets/register_band_name.dart';
import 'package:band_name_survey/widgets/register_user.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

//import 'carousel_slider.dart';
import 'widgets/band_detail.dart';


void main() => runApp(App());

//void main() => runApp(CarouselDemo());

class App extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(),
      child: MainScreen(),
    );
  }
}

class CarouselSliderClass extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Carousel Slider Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Carousel Slider'),),
        body: CarouselSlider(
          height: 400.0,
          items: [1,2,3,4,5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber
                  ),
                  child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                );
              },
            );
          }).toList(),
          autoPlay: true,
          pauseAutoPlayOnTouch: Duration(seconds: 5),
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
        )
      )
    );
  }
}

class MainScreen extends StatefulWidget
{
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  AuthBloc authBloc;

  @override
  void initState()
  {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(LoggedOut());
    super.initState();
  }

  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Band Names',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<AuthenticationState>(
        stream: authBloc.authState,
        initialData: AuthenticationUnauthenticated(),
        builder: (BuildContext context, AsyncSnapshot<AuthenticationState> snapshot){
          final state = snapshot.data;
          if(state is AuthenticationAuthenticated)
          {
            return BandMainScreen();
          }
          if(state is AuthenticationUnauthenticated)
          {
            final LoginScreenArguments arguments = ModalRoute.of(context).settings.arguments;
            final message = state.message ?? arguments?.message;
            state.message = null;
            return LoginScreen(message: message);
          }
          if(state is AuthenticationLoading)
          {
            return LoadingScreen();
          }
          return Container(width: 0, height: 0);
        },
      ),
      routes: {
       RegisterBand.route: (context) => RegisterBand(),
       RegisterScreen.route: (context) => RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings){
        if(settings.name == BandDetailScreen.route)
        {
          final BandDetailArguments arguments = settings.arguments;
          return MaterialPageRoute(
          //  builder: (context) => Scaffold(
          //    body: BandDetailScreen(documentSnapshot: arguments.documentSnapshot,),
          //  )
          builder: (context) => BandDetailScreen(documentSnapshot: arguments.documentSnapshot,)
          );
        }
        return null;
      },
    );
  }
}


class LoadingScreen extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      )
    );
  }
}
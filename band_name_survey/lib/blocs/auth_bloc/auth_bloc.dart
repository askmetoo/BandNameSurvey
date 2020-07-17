

import 'dart:async';

import 'package:band_name_survey/blocs/auth_bloc/events.dart';
import 'package:band_name_survey/blocs/auth_bloc/states.dart';
import 'package:band_name_survey/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase
{

  final BehaviorSubject<AuthenticationState> _authController = BehaviorSubject<AuthenticationState>();
  Stream<AuthenticationState> get authState => _authController.stream;
  StreamSink<AuthenticationState> get _inAuth => _authController.sink;


  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      _inAuth.add(state);
    }
  }


  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    // if (event is AppStarted) {
    //   final bool isAuth = await auth.isAuthenticated();

    //   if (isAuth) {
    //     await auth.fetchAuthUser().catchError((error) {
    //       dispatch(LoggedOut());
    //     });
    //     yield AuthenticationAuthenticated();
    //   } else {
    //     yield AuthenticationUnauthenticated();
    //   }
    // }

    if (event is InitLogging) {
      print('InitLogging');
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      print('LoggedIn');
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      print('LoggedOut');
      yield AuthenticationUnauthenticated(message: event.message);
    }
  }

  @override
  void dispose() {
    _authController.close();
  }
}
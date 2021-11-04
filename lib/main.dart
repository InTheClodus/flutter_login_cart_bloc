import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/app.dart';
import 'package:flutter_login/shopping_repository.dart';
import 'package:flutter_login/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
      shoppingRepository: ShoppingRepository()));
}

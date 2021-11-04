import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/cart/bloc/cart_bloc.dart';
import 'package:flutter_login/cart/view/cart_page.dart';
import 'package:flutter_login/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/shopping_repository.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:user_repository/user_repository.dart';

import 'catalog/view/catalog_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.shoppingRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  final ShoppingRepository shoppingRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(shoppingRepository: shoppingRepository,),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key, required this.shoppingRepository}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
  final ShoppingRepository shoppingRepository;
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CatalogBloc(
              shoppingRepository: widget.shoppingRepository,
            )..add(CatalogStarted()),
          ),
          BlocProvider(
            create: (_) => CartBloc(
              shoppingRepository: widget.shoppingRepository,
            )..add(CartStarted()),
          )
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      CatalogPage.route(),
                      (route) => false,
                    );
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(),
                      (route) => false,
                    );
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },

          routes: {
            '/': (_) => SplashPage(),
            '/catalog': (_) => CatalogPage(),
            '/cart': (_) => CartPage(),
            '/home': (_) => HomePage(),
          },
          initialRoute: '/',
          // onGenerateRoute: (RouteSettings settings){
          //   return MaterialPageRoute(builder: (context){
          //
          //   })
          // },
        ));
  }

}

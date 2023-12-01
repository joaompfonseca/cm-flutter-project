import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hw_map/Data/AWS/aws_cognito.dart';
import 'package:hw_map/app.dart';
import 'package:hw_map/cubit/map.dart';
import 'package:hw_map/cubit/poi.dart';
import 'package:hw_map/cubit/route.dart';
import 'package:hw_map/login/login.dart';
import 'package:hw_map/map/config.dart';
import 'package:hw_map/mock/poi.dart';
import 'package:hw_map/mock/route.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  var aws = AWSServices();
  runApp(MyApp(
    loogedIn: false,
    aws: aws,
  ));
}

class MyApp extends StatelessWidget {
  final bool loogedIn;
  final AWSServices aws;
  const MyApp({super.key, required this.loogedIn, required this.aws});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project X App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.orangeAccent,
          foregroundColor: Colors.black,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black45,
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Color.fromRGBO(255, 243, 224, 1),
          selectedTileColor: Colors.orange,
          iconColor: Colors.black,
          textColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MapCubit>(
            create: (context) => MapCubit(
              MapState(
                mapController,
                osmOption,
              ),
            ),
          ),
          BlocProvider<PoiCubit>(
            create: (context) => PoiCubit(mockPoiList),
          ),
          BlocProvider<RouteCubit>(
            create: (context) => RouteCubit(mockRouteList),
          ),
        ],
        child: loogedIn ? const App() : LoginPage(aws: aws),
      ),
    );
  }
}

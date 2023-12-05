import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_x/app.dart';
import 'package:project_x/cubit/geocoding.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/position.dart';
import 'package:project_x/cubit/profile.dart';
import 'package:project_x/cubit/route.dart';
import 'package:project_x/login/login.dart';
import 'package:project_x/map/config.dart';
import 'package:project_x/mock/poi.dart';
import 'package:project_x/mock/profile.dart';
import 'package:project_x/mock/route.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await _configureAmplify();
  //final session = await Amplify.Auth.fetchAuthSession(
  //  options: CognitoSessionOptions(getAWSCredentials: true),
  //);
  //AWSCognitoUserPoolTokens awsCognitoUserPoolTokens =
  //    (session as CognitoAuthSession).userPoolTokens!;
  //safePrint(awsCognitoUserPoolTokens.accessToken.raw);
  runApp(MyApp());
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugins([auth]);
    await Amplify.configure(amplifyconfig);
    safePrint('Amplify configured successfully');
  } catch (e) {
    safePrint('Amplify could not be configured');
  }
}

class MyApp extends StatefulWidget {
  final bool isLogged = false;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLogged;
  @override
  void initState() {
    super.initState();
    isLogged = widget.isLogged;
  }

  @override
  Widget build(BuildContext context) {
    final positionCubit = PositionCubit(null);
    final graphhopperCubit = GraphhopperCubit([]);
    final geocodingCubit = GeocodingCubit(GeocodingState(null, null));
    final profileCubit = ProfileCubit(mockProfile);
    final mapCubit = MapCubit(
      MapState(mapController, mapOptions, null, false, positionCubit),
    );
    final poiCubit = PoiCubit(mockPoiList);
    final routeCubit = RouteCubit(
      RouteState(
        createdRouteList: mockRouteList,
        trackedRouteList: [],
        isCreatingRoute: false,
        isTrackingRoute: false,
        trackedRoutePointList: [],
        displayedRoute: null,
        displayedRoutePoints: [],
        positionCubit: positionCubit,
        graphhopperCubit: graphhopperCubit,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<PositionCubit>(
          create: (context) => positionCubit,
        ),
        BlocProvider<GraphhopperCubit>(
          create: (context) => graphhopperCubit,
        ),
        BlocProvider<GeocodingCubit>(
          create: (context) => geocodingCubit,
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => profileCubit,
        ),
        BlocProvider<MapCubit>(
          create: (context) => mapCubit,
        ),
        BlocProvider<PoiCubit>(
          create: (context) => poiCubit,
        ),
        BlocProvider<RouteCubit>(
          create: (context) => routeCubit,
        ),
      ],
      child: MaterialApp(
        title: 'Project X App',
        theme: ThemeData(
          // Daisy UI Light
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF491EFF), // primary
            onPrimary: Color(0xFFFFFFFF), // base 100
            secondary: Color(0xFFFF41C7), // secondary
            onSecondary: Color(0xFFFFFFFF), // base 100
            tertiary: Color(0xFF00CFBD), // accent
            onTertiary: Color(0xFFFFFFFF), // base 100
            error: Color(0xFFEF4444), // CUSTOM
            onError: Color(0xFFFFFFFF), // base 100
            background: Color(0xFFFFFFFF), // base 100
            onBackground: Color(0xFF1F2937), // base content
            surface: Color(0xFFFFFFFF), // base 100
            onSurface: Color(0xFF1F2937), // base content
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2B3440), // neutral
            foregroundColor: Color(0xFFD7DDE4), // neutral content
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF1F2937), // base content
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          // Daisy UI Dark
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF7582FF), // primary
            onPrimary: Color(0xFF1D232A), // base 100
            secondary: Color(0xFFFF71CF), // secondary
            onSecondary: Color(0xFF1D232A), // base 100
            tertiary: Color(0xFF00C7B5), // accent
            onTertiary: Color(0xFF1D232A), // base 100
            error: Color(0xFFEF4444), // CUSTOM
            onError: Color(0xFF1D232A), // base 100
            background: Color(0xFF1D232A), // base 100
            onBackground: Color(0xFFA6ADBB), // base content
            surface: Color(0xFF1D232A), // base 100
            onSurface: Color(0xFFA6ADBB), // base content
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2A323C), // neutral
            foregroundColor: Color(0xFFA6ADBB), // neutral content
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFFA6ADBB), // base content
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: FutureBuilder(
          future: Amplify.Auth.fetchAuthSession(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data!.isSignedIn) {
                  return const App();
                } else {
                  return const LoginPage();
                }
              }
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

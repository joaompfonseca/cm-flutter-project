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
import 'package:project_x/cubit/token.dart';
import 'package:project_x/login/login.dart';
import 'package:project_x/map/config.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:project_x/poi/poi.dart';
import 'package:project_x/profile/create.dart';
import 'package:project_x/profile/profile.dart';
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
  runApp(const MyApp());
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
    final tokenCubit = TokenCubit();
    final positionCubit = PositionCubit(null);
    final graphhopperCubit = GraphhopperCubit(
      GraphhopperState(
        points: [],
        instructions: [],
        instructionIndex: 0,
        distance: "",
        time: "",
      ),
    );
    final geocodingCubit = GeocodingCubit(GeocodingState(
      location: null,
      coordinates: null,
    ));
    final profileCubit = ProfileCubit(
      ProfileState(
        profile: Profile(
          id: "",
          email: "",
          username: "",
          cognitoId: "",
          firstName: "",
          lastName: "",
          pictureUrl: "",
          createdAt: DateTime.now(),
          birthDate: DateTime.now(),
          totalXp: 0,
          addedPoisCount: 0,
          givenRatingsCount: 0,
          receivedRatingsCount: 0,
        ),
        tokenCubit: tokenCubit,
      ),
    );
    final poiCubit = PoiCubit(
      PoiState(
        totalPoiList: <Poi>[],
        filtering: false,
        poiList: <Poi>[],
        name: TextEditingController(),
        tokenCubit: tokenCubit,
      ),
    );
    final mapCubit = MapCubit(
      MapState(
        mapController: mapController,
        mapOptions: mapOptions,
        userPosition: null,
        isTrackingUserPosition: false,
        positionCubit: positionCubit,
        poiCubit: poiCubit,
      ),
    );
    final routeCubit = RouteCubit(
      RouteState(
        createdRouteList: [],
        trackedRouteList: [],
        isCreatingRoute: false,
        isTrackingRoute: false,
        createdRouteLocationList: [
          TextEditingController(),
          TextEditingController(),
        ],
        trackedRoutePointList: [],
        displayedRoute: null,
        displayedRoutePoints: [],
        positionCubit: positionCubit,
        graphhopperCubit: graphhopperCubit,
        tokenCubit: tokenCubit,
        geocodingCubit: geocodingCubit,
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
        BlocProvider<TokenCubit>(
          create: (context) => tokenCubit,
        ),
      ],
      child: MaterialApp(
        title: "BiX App",
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
                  return FutureBuilder(
                      future: profileCubit.getProfile(),
                      builder: (context, snapshot) {
                        safePrint(snapshot.data.toString());
                        if (snapshot.data.toString() == 'true') {
                          routeCubit.getRoutes();
                          return const App();
                        } else if (snapshot.data.toString() == 'false') {
                          return const CreateProfileForm();
                        } else {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      });
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

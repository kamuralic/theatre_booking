import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beamer/beamer.dart';
import 'package:theatrol/model/show.dart';
import 'package:theatrol/screen/authentication/login_screen.dart';
import 'package:theatrol/screen/detail/checkout_screen.dart';
import 'package:theatrol/screen/detail/detail_screen.dart';
import 'package:theatrol/screen/main/main_screen.dart';
import 'package:theatrol/screen/main/setting/settings_screen.dart';
import 'package:theatrol/screen/main/transaction/transaction_history_screen.dart';
import 'package:theatrol/screen/post_show_page.dart';
import 'package:theatrol/screen/search_screen.dart';
import 'package:theatrol/services/auth_service.dart';
import 'package:theatrol/services/image_storage.dart';
import 'package:theatrol/services/images_provider.dart';
import 'package:theatrol/services/performances_service.dart';
import 'package:theatrol/services/seats_service.dart';
import 'package:theatrol/services/shows_service.dart';
import 'package:theatrol/services/tickets_service.dart';
import 'package:theatrol/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final skipOnBoarding = prefs.getBool("skipOnBoarding") ?? false;
  runApp(MyApp(skipOnBoarding: skipOnBoarding));
}

class MyApp extends StatefulWidget {
  final bool skipOnBoarding;

  const MyApp({Key? key, required this.skipOnBoarding}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state, data) => MainScreen(),
        '/login': (context, state, data) => const LoginPage(),
        '/transactions': (context, state, data) => TransactionHistoryScreen(),
        '/add-show': (context, state, data) => const ShowPostPage(),
        // '/account': (context, state, data) => SettingsScreen(),
        // '/shows': (context, state, data) => SearchScreen(
        //       selectedDropdownItem: "All",
        //     ),
        '/show-details': (context, state, data) {
          // Take the path parameter of interest from BeamState
          ////final playId = state.pathParameters['playId']!;
          // Collect arbitrary data that persists throughout navigation
          final info = (data as Show);
          // Use BeamPage to define custom behavior
          return BeamPage(
            key: ValueKey('show-${data.id}'),
            title: 'Play Screen',
            popToNamed: '/',
            type: BeamPageType.scaleTransition,
            child: DetailScreen(show: info),
          );
        },

        '/checkout': (context, state, data) {
          // Take the path parameter of interest from BeamState
          ////final playId = state.pathParameters['playId']!;
          // Collect arbitrary data that persists throughout navigation
          final info = (data as Show);
          // Use BeamPage to define custom behavior
          return BeamPage(
            key: ValueKey('checkout-${data.id}'),
            title: 'CheckOut',
            popToNamed: '/',
            type: BeamPageType.scaleTransition,
            child: CheckoutScreen(show: info),
          );
        }
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Provider<ShowsService>(create: (_) => ShowsService()),
        Provider<ImageStorageService>(create: (_) => ImageStorageService()),
        ChangeNotifierProvider(create: (_) => ShowsService()),
        ChangeNotifierProvider(create: (_) => SeatsService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => PerformancesService()),
        ChangeNotifierProvider(create: (_) => TicketsService()),
      ],
      child: MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        title: 'Theatrol',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: createMaterialColor(primaryColor500),
            canvasColor: colorWhite),
        // home: widget.skipOnBoarding
        //     ? MainScreen(currentScreen: 0)
        //     : OnboardingScreen(),
      ),
    );
  }
}

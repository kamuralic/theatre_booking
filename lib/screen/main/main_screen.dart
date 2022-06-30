import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/screen/main/home/home_screen.dart';

import '../../services/auth_service.dart';
import '../../theme.dart';

class MainScreen extends StatefulWidget {
  int currentScreen = 0;

  MainScreen({this.currentScreen = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProvider = context.read<AuthService>();
      authProvider.getUserId();
      authProvider.getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          // elevation: 0,
          toolbarHeight: 65,

          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: backgroundColor,
              statusBarIconBrightness: Brightness.dark),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //width: ,
                child: const Text(
                  'THEATROL',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Beamer.of(context).beamToNamed('/');
                      },
                      child: const Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Consumer<AuthService>(builder: (_, notifier, __) {
              return notifier.userNamePrefs == null
                  ? InkWell(
                      onTap: () {
                        Beamer.of(context).beamToNamed('/login');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        color: colorWhite,
                        child: const Text('Login',
                            style: TextStyle(
                                color: primaryColor500,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "assets/images/user_profile_example.png"),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(notifier.userNamePrefs!),
                            InkWell(
                              onTap: () {
                                notifier.logout();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                color: colorWhite,
                                child: const Text('Logout',
                                    style: TextStyle(
                                        color: primaryColor500,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
            }),
          ],
        ),
        backgroundColor: backgroundColor,
        body: HomeScreen(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit the App'),
            content: const Text('Do you want to exit the application?'),
            actions: <Widget>[
              // const SizedBox(height: 16),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

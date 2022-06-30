import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/services/preferences_service.dart';
import 'package:theatrol/services/shows_service.dart';
import 'package:theatrol/theme.dart';
import 'package:theatrol/widget/show_card.dart';
import 'package:theatrol/widget/ticket_card.dart';

import '../../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrefService prefService = PrefService();
  @override
  void initState() {
    super.initState();
    prefService.getUser().then((value) => print(value));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProvider = context.read<AuthService>();

      ShowsService showsProvider = context.read<ShowsService>();

      authProvider.getUserId();
      showsProvider.getShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final authProvider = context.read<AuthService>();

    var horrizontalPadding = MediaQuery.of(context).size.width * 0.25 / 2;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          //Card(child: CategoriesWidget()),
          header(context),
          TicketCard(),
          Card(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horrizontalPadding, vertical: 25),
                child: Row(
                  children: [
                    Text(
                      "Up Comming Plays",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horrizontalPadding),
                child: Consumer<ShowsService>(builder: (_, notifier, __) {
                  return notifier.isLoaded
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 3,
                            staggeredTileBuilder: (int index) =>
                                const StaggeredTile.fit(1),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notifier.shows!.length,
                            itemBuilder: (context, index) {
                              return ShowCard(show: notifier.shows![index]);
                            },
                          ),
                        )
                      : const CircularProgressIndicator();
                }),
              ),
            ],
          ))
        ]))
      ]),
    );
  }

  Widget header(context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        margin: const EdgeInsets.only(left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'BOOK YOUR ',
              style: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'TICKETS FOR',
              style: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'OUR PLAYS',
              style: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: primaryColor500,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              primaryColor500.withOpacity(0.5), BlendMode.dstATop),
          fit: BoxFit.cover,
          image: const AssetImage("assets/images/hero_image.jpg"),
        ),
      ),
    );
  }
}

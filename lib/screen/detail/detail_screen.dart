import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:theatrol/model/show.dart';
import 'package:theatrol/widget/my_progress_indicator.dart';
import '../../theme.dart';

class DetailScreen extends StatefulWidget {
  final Show show;

  DetailScreen({required this.show});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> datesList =
        getDaysInBetween(widget.show.startDate, widget.show.endDate);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          customSliverAppBar(context, widget.show),
          SliverPadding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.show.description,
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Availability:",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'Start : ${DateFormat.yMEd().format(widget.show.startDate)}',
                      style: descTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: datesList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       if (index == 0 || index == datesList.length - 1) {
                //         return const Text('');
                //       } else {
                //         return Row(
                //           children: [
                //             const SizedBox(
                //               width: 32.0,
                //             ),
                //             Text(
                //               'Day ${index + 1}  : ${DateFormat.yMEd().format(datesList[index])}',
                //               style: descTextStyle,
                //             ),
                //           ],
                //         );
                //       }
                //     }),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'End  : ${DateFormat.yMEd().format(widget.show.endDate)}',
                      style: descTextStyle,
                    ),
                  ],
                ),
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: lightBlue300,
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ]),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusSize))),
            onPressed: () {
              context.beamToNamed('/checkout', data: widget.show);
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return CheckoutScreen(
              //     show: show,
              //   );
              // }));
            },
            child: const Text("Book Now")),
      ),
    );
  }

  Widget customSliverAppBar(context, Show show) {
    return SliverAppBar(
      shadowColor: primaryColor500.withOpacity(.2),
      backgroundColor: colorWhite,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.4),
        statusBarIconBrightness: Brightness.light,
      ),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          decoration: const BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadiusSize))),
          child: Center(
            child: Text(
              show.title,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        background: CachedNetworkImage(
          fit: BoxFit.fitHeight,
          imageUrl: show.imageUrl,
          placeholder: (context, url) => const MyCircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: colorWhite,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 26,
              icon: const Icon(
                Icons.arrow_back,
                color: darkBlue500,
              )),
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height * 0.7,
    );
  }
}

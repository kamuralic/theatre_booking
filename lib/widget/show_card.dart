import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/model/show.dart';
import 'package:theatrol/screen/detail/detail_screen.dart';
import 'package:theatrol/widget/my_progress_indicator.dart';

import '../services/auth_service.dart';
import '../theme.dart';

class ShowCard extends StatefulWidget {
  final Show show;

  const ShowCard({Key? key, required this.show}) : super(key: key);

  @override
  State<ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProvider = context.read<AuthService>();
      authProvider.getUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 16, left: 16, top: 4.0, bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return DetailScreen(field: field,);
          // }));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: colorWhite,
              boxShadow: [
                BoxShadow(
                  color: primaryColor500.withOpacity(0.1),
                  blurRadius: 20,
                )
              ]),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(borderRadiusSize)),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            memCacheHeight: 200,
                            memCacheWidth: 200,
                            height: 200,
                            fit: BoxFit.fill,
                            //width: 60,
                            imageUrl: widget.show.imageUrl,
                            placeholder: (context, url) =>
                                // ignore: sized_box_for_whitespace
                                const MyCircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.show.title,
                      maxLines: 2,
                      style: subTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                              'Start: ' +
                                  DateFormat('dd/MM/yyyy')
                                      .format(widget.show.startDate),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            'Duration: ' +
                                widget.show.endDate
                                    .difference(widget.show.startDate)
                                    .inDays
                                    .toString() +
                                ' Days',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                    ///Details button link
                    Consumer<AuthService>(builder: (_, notifier, __) {
                      return notifier.userIdPrefs != null
                          ? InkWell(
                              onTap: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return DetailScreen(show: show);
                                // }));
                                context.beamToNamed('/show-details',
                                    data: widget.show);
                              },
                              child: Container(
                                  width: 100,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: const Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    color: primaryColor500,
                                  ),
                                  child: const Text(
                                    'Details',
                                    style: TextStyle(color: colorWhite),
                                  )),
                            )
                          : const Text('');
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

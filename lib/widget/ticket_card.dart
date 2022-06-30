import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({Key? key}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Show Name',
            style: TextStyle(),
          ),
          Text('Show Date'),
          Text('Show Time')
        ]),
      ),
    );
  }
}

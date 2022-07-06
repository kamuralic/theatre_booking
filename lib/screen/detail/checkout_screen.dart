import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/model/performance.dart';
import 'package:theatrol/model/seat.dart';
import 'package:theatrol/model/show.dart';
import 'package:theatrol/model/ticket.dart';
import 'package:theatrol/services/auth_service.dart';
import 'package:theatrol/services/performances_service.dart';
import 'package:theatrol/services/seats_service.dart';
import 'package:theatrol/widget/my_progress_indicator.dart';
import '../../remote_repository/tickets.dart';
import '../../services/tickets_service.dart';
import '../../theme.dart';

class CheckoutScreen extends StatefulWidget {
  final Show show;

  const CheckoutScreen({Key? key, required this.show}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Seat? _selectedSeat;
  int _selectedIndex = -1;
  int? _performanceId;
  String? _selectedPerfomanceName;
  bool _isSeatSelected = false;
  // List<Ticket> tickets = [];

  int _totalBill = 0;

  String _performanceTypeErrorMessage = '';
  String _seatErrorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProvider = context.read<AuthService>();
      final seatsProvider = context.read<SeatsService>();
      final ticketsProvider = context.read<TicketsService>();

      final performanceProvider = context.read<PerformancesService>();

      performanceProvider.getPerformances();
      seatsProvider.getSeats();
      ticketsProvider.getTickets();

      authProvider.getUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthService>();
    final remoteTicketsService = RemoteTicketsService();
    final ticketsProvider = context.read<TicketsService>();

    print(ticketsProvider.tickets);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorWhite,
              statusBarIconBrightness: Brightness.dark,
            ),
            title: Text("Checkout"),
            backgroundColor: colorWhite,
            centerTitle: true,
            foregroundColor: primaryColor500,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Show Name",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor100, width: 2),
                        color: lightBlue100,
                        borderRadius: BorderRadius.circular(borderRadiusSize)),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 24,
                          height: 24,
                          color: primaryColor500,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(widget.show.title,
                            style: normalTextStyle.copyWith(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Pick Performance Time",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Consumer<PerformancesService>(builder: (_, notifier, __) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor100, width: 2),
                          color: lightBlue100,
                          borderRadius:
                              BorderRadius.circular(borderRadiusSize)),
                      child: notifier.isLoaded == true
                          ? DropdownButton<String>(
                              value: _selectedPerfomanceName,
                              items: notifier.performances!.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value.performanceType,
                                  child: Text(value.performanceType),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                Performance performance = notifier.performances!
                                    .firstWhere((element) =>
                                        element.performanceType == newVal);
                                setState(() {
                                  _performanceId = performance.id;

                                  _selectedPerfomanceName = newVal;
                                  _performanceTypeErrorMessage = '';
                                  _totalBill = performance.pricePerSeat;
                                });
                              },
                            )
                          : const MyCircularProgressIndicator(),
                    );
                  }),
                  Text(
                    _performanceTypeErrorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Pick A Seat ( Yellow seats already booked)",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Consumer<SeatsService>(builder: (_, notifier, __) {
                    return notifier.isLoaded == true
                        //? Text(notifier.shows![0].title)
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 6,
                              staggeredTileBuilder: (int index) =>
                                  const StaggeredTile.fit(1),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notifier.seats!.length,
                              itemBuilder: (context, index) {
                                Seat seat = notifier.seats![index];

                                List<Ticket> tickets = [];
                                if (ticketsProvider.isLoaded == true &&
                                    _performanceId != null) {
                                  tickets = ticketsProvider.tickets!
                                      .where((element) =>
                                          element.seatId == seat.id &&
                                          element.showId == widget.show.id &&
                                          element.performanceId ==
                                              _performanceId)
                                      .toList();
                                }

                                return InkWell(
                                  onTap: tickets.isNotEmpty
                                      ? null
                                      : (() {
                                          setState(() {
                                            _isSeatSelected = !_isSeatSelected;
                                            _selectedSeat =
                                                _isSeatSelected == false
                                                    ? null
                                                    : seat;
                                            _seatErrorMessage = '';

                                            if (_selectedIndex == index) {
                                              _selectedIndex = -1;
                                            } else {
                                              _selectedIndex = index;
                                            }
                                          });
                                        }),
                                  child: Card(
                                    color: index == _selectedIndex ||
                                            tickets.isNotEmpty
                                        ? Colors.yellow
                                        : Colors.green,
                                    // height: 50,
                                    // width: 50,
                                    child: Text(
                                      seat.row + seat.column.toString(),
                                      style: const TextStyle(
                                          color: colorWhite,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const MyCircularProgressIndicator();
                  }),
                  Text(
                    _seatErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ])),
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
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total:",
                  style: descTextStyle,
                ),
                Text(
                  "EUR $_totalBill",
                  style: priceTextStyle,
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(borderRadiusSize))),
                  onPressed: _performanceId == null ||
                          _selectedSeat == null ||
                          isLoading == true
                      ? null
                      : () {
                          if (_performanceId == null) {
                            setState(() {
                              _performanceTypeErrorMessage =
                                  'Please select a performance Time name';
                            });
                            return;
                          }
                          if (_selectedSeat == null) {
                            setState(() {
                              _seatErrorMessage = 'Please select a seat';
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          remoteTicketsService.createTicket(
                              seatId: _selectedSeat!.id!,
                              performanceId: _performanceId!,
                              userId: authProvider.userIdPrefs!,
                              showId: widget.show.id!);
                          setState(() {
                            isLoading = false;
                          });
                          _showSnackBar(
                              context, 'Successfully Booked A theatre seat');
                        } //!_enableCreateOrderBtn

                  ,
                  child: Text(
                    isLoading == true ? "Loading..." : "Create Order",
                    style: buttonTextStyle,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }
}

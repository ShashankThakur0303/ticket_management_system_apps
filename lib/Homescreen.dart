import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Login/login.dart';
import 'package:ticket_management_system/responsive/responsive.dart';
import 'package:ticket_management_system/screens/filter_report.dart';
import 'package:ticket_management_system/screens/notification.dart';
import 'package:ticket_management_system/screens/pending.dart';
import 'package:ticket_management_system/screens/profile.dart';
import 'package:ticket_management_system/screens/raise.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.userID});
  String userID;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  int notificationNum = 0;

  List<String> buttons = [
    'Raise Ticket',
    'Pending Tickets',
    'Reports',
    'Profile',
  ];

  List<Widget Function(String)> screens = [
    (userID) => Raise(
          userID: userID,
        ),
    //Pending(),
    (userID) => pending(),
    (userID) => const FilteredReport(),
    (userID) => profile(
          userID: userID,
        ),
  ];

  int resolvedTicketLen = 0;
  int pendingTicketLen = 0;

  @override
  void initState() {
    getPendingTicket().whenComplete(() async {
      await getNotification();
      await getResolvedTicket();
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ReponsiveWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'T.🅼.S',
            style: TextStyle(color: Colors.deepPurple, fontSize: 30),
          ),
          leading: Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  size: 30,
                  Icons.notifications_active,
                  color: Colors.deepPurple,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    notificationNum.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
                  // );
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.deepPurple,
                )),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  bool isLandscape =
                      constraints.maxWidth > constraints.maxHeight;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.95,
                            height: screenSize.height * 0.5,
                            child: GridView.builder(
                              itemCount: buttons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isLandscape ? 4 : 2,
                                childAspectRatio: isLandscape ? 1.2 : 1,
                                crossAxisSpacing: 4.0,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  screens[index](widget.userID),
                                            ),
                                          ),
                                          child: getIcon(buttons[index]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                screens[index](widget.userID),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        buttons[index],
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 10.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: const Text(
                                      'Ticket Overview',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            RichText(
                                              text: TextSpan(children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5.0,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.purple,
                                                      child: Text(
                                                        pendingTicketLen
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    width: 10,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: Text(
                                                    'Pending Ticket',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            RichText(
                                              text: TextSpan(children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5.0,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.orange,
                                                      child: Text(
                                                        resolvedTicketLen
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    width: 10,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: Text(
                                                    'Completed Ticket',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: PieChart(
                                            PieChartData(
                                              centerSpaceRadius: 20,
                                              sections: [
                                                PieChartSectionData(
                                                  color: Colors.deepPurple,
                                                  value: 40,
                                                  title: pendingTicketLen
                                                      .toString(),
                                                  titleStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                  radius: 40,
                                                ),
                                                PieChartSectionData(
                                                  color: Colors.orange,
                                                  value: 20,
                                                  title: resolvedTicketLen
                                                      .toString(),
                                                  titleStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                  radius: 40,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future getNotification() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("resolvedTicket")
        .where('isSeen', isEqualTo: false)
        .get();

    notificationNum = querySnapshot.docs.length;
    print("notification - $notificationNum");
  }

  Future getPendingTicket() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('raisedTickets').get();

    List<dynamic> pendingTicketData =
        querySnapshot.docs.map((e) => e.id).toList();
    pendingTicketLen = pendingTicketData.length;
  }

  Future getResolvedTicket() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('resolvedTicket').get();

    List<dynamic> resolvedTicketData =
        querySnapshot.docs.map((e) => e.id).toList();
    resolvedTicketLen = resolvedTicketData.length;
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      case "Raise Ticket":
        return const Icon(
          Icons.receipt_long_rounded,
          size: 70,
          color: Colors.deepPurple,
        );
      case "Reports":
        return const Icon(
          Icons.report_sharp,
          size: 70,
          color: Colors.deepPurple,
        );
      case "Profile":
        return const Icon(
          Icons.person_outlined,
          size: 70,
          color: Colors.deepPurple,
        );
      default:
        return const Icon(
          Icons.pending_actions_outlined,
          size: 70,
          color: Colors.deepPurple,
        );
    }
  }
}

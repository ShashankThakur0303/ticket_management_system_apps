import 'package:flutter/material.dart';
import 'package:ticket_management_system/Service%20Provider/Servicelogin.dart';
import 'package:ticket_management_system/Service%20Provider/pending_service.dart';
import 'package:ticket_management_system/Service%20Provider/service_profile.dart';
import 'package:ticket_management_system/Service%20Provider/service_report1.dart';

class Homeservice extends StatefulWidget {
  const Homeservice({super.key});

  @override
  State<Homeservice> createState() => HomeserviceState();
}

class HomeserviceState extends State<Homeservice> {
  List<String> buttons = [
    //  'Raise Ticket',
    'Pending Tickets',
    'Reports',
    'Profile',
  ];

  List<Widget Function()> screens = [
    // () => Raise(),
    () => service_pending(),
    () => const ServiceReportScreen(),
    () => const serviceProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'T.🅼.S',
            style: TextStyle(color: Colors.deepPurple, fontSize: 30),
          ),
          // leading: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.notifications_active,
          //       color: Colors.deepPurple,
          //     )),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginService()));
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.deepPurple,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: GridView.builder(
                            itemCount: buttons.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10.0),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Column(
                                    children: [
                                      Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: InkWell(
                                                onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              screens[index]()),
                                                    ),
                                                child: getIcon(buttons[index])),
                                          )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  screens[index](),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          buttons[index],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            })),
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Card(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'Complaint Overview',
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.black,
                //             fontSize: 30),
                //       ),
                //       const Divider(
                //         color: Colors.grey,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   const CircleAvatar(
                //                     radius: 15,
                //                     child: Text('7'),
                //                   ),
                //                   const SizedBox(
                //                     width: 8,
                //                   ),
                //                   Container(
                //                       margin: const EdgeInsets.only(top: 11),
                //                       child: const Text(
                //                         'Raise Ticket',
                //                         style: TextStyle(fontSize: 15),
                //                       )),
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: 15,
                //               ),
                //               Row(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   const CircleAvatar(
                //                     radius: 15,
                //                     backgroundColor: Colors.orange,
                //                     child: Text(
                //                       '8',
                //                       style: TextStyle(color: Colors.white),
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     width: 8,
                //                   ),
                //                   Container(
                //                       margin: const EdgeInsets.only(top: 11),
                //                       child: const Text(
                //                         'Pending Ticket',
                //                         style: TextStyle(fontSize: 15),
                //                       )),
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: 15,
                //               ),
                //               Row(
                //                 children: [
                //                   const CircleAvatar(
                //                     backgroundColor: Colors.deepPurple,
                //                     radius: 15,
                //                     child: Text(
                //                       '10',
                //                       style: TextStyle(color: Colors.white),
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     width: 8,
                //                   ),
                //                   Container(
                //                       margin: const EdgeInsets.only(top: 11),
                //                       child: const Text(
                //                         'Completed Ticket',
                //                         style: TextStyle(fontSize: 15),
                //                       )),
                //                 ],
                //               ),
                //             ],
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(7),
                //             child: Container(
                //               width: 180,
                //               height: 180,
                //               child: PieChart(
                //                 PieChartData(
                //                   sections: [
                //                     PieChartSectionData(
                //                       color: Colors.blue,
                //                       value: 30,
                //                       title: 'A',
                //                       titleStyle: TextStyle(color: Colors.blue),
                //                       radius: 10,
                //                     ),
                //                     PieChartSectionData(
                //                       color: Colors.deepPurple,
                //                       value: 40,
                //                       title: 'B',
                //                       titleStyle:
                //                           TextStyle(color: Colors.deepPurple),
                //                       radius: 10,
                //                     ),
                //                     PieChartSectionData(
                //                       color: Colors.orange,
                //                       value: 20,
                //                       title: 'C',
                //                       titleStyle:
                //                           TextStyle(color: Colors.orange),
                //                       radius: 10,
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // )///
              ],
            ),
          ),
        ));
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      // case "Raise Ticket":
      //   return const Icon(
      //     Icons.receipt_long_rounded,
      //     size: 85,
      //     color: Colors.deepPurple,
      //   );
      // case "Pending Ticket":
      //   return const Icon(
      //     Icons.messenger_outline_rounded,
      //     size: 85,
      //   );
      case "Reports":
        return const Icon(
          Icons.report_sharp,
          size: 85,
          color: Colors.deepPurple,
        );
      case "Profile":
        return const Icon(
          Icons.person_outlined,
          size: 85,
          color: Colors.deepPurple,
        );

      default:
        return const Icon(
          Icons.pending_actions_outlined,
          size: 85,
          color: Colors.deepPurple,
        );
    }
  }
}

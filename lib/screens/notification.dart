import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/screens/ticket_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> tickets = [];
  List<String> ticketsTitle = [];
  bool isLoading = true;

  @override
  void initState() {
    getCompletedTickets().whenComplete(() {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
        ),
        centerTitle: true,
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Text("No Tickets Available"),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: tickets.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Card(
                            elevation: 10.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketScreen(
                                        Number: tickets[index],
                                        showResolvedTickets: true,
                                      ),
                                    ));
                              },
                              title: Text("Ticket ${tickets[index]}"),
                              subtitle: const Text("Closed"),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
    );
  }

  Future getCompletedTickets() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("raisedTickets")
        .where('isSeen', isEqualTo: false)
        .get();

    tickets = querySnapshot.docs.map((data) => data.id).toList();
    setNotificationIsSeen();
  }

  Future setNotificationIsSeen() async {
    tickets.forEach(
      (element) {
        FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(element)
            .update({"isSeen": true});
      },
    );
    print("Notification is seen");
  }
}

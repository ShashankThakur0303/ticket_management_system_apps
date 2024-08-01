import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_management_system/screens/display_report.dart';

class FilteredReport extends StatefulWidget {
  const FilteredReport({super.key});

  @override
  State<FilteredReport> createState() => _FilteredReportState();
}

class _FilteredReportState extends State<FilteredReport> {
  List<dynamic> filterData = [];
  final tickerNumController = TextEditingController();
  final bldgController = TextEditingController();
  final assetController = TextEditingController();
  final floorController = TextEditingController();
  final serviceProviderController = TextEditingController();
  final roomController = TextEditingController();
  final statusController = TextEditingController();
  final workController = TextEditingController();

  List<String> buildings = [];
  List<String> assets = [];
  List<String> floors = [];
  List<String> rooms = [];
  List<String> works = [];
  List<String> serviceProviders = [];
  List<String> status = ["All", "Open", "Close"];

  String? selectedBuilding;
  String? selectedFloor;
  String? selectedRoom;
  String? selectedAsset;
  String? selectedWork;
  String? selectedStatus;
  String? selectedServiceProvider;
  bool isLoading = true;
  String? _selectDate;
  List<dynamic> ticketList = [];

  @override
  void initState() {
    getBuildings().whenComplete(() {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tickets Report'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              getCalendar();
                            },
                            child: const Text(
                              "Select Date",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextField(
                        controller: tickerNumController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Search Ticket Number',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedBuilding,
                              items: buildings.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedBuilding = value;
                                getFloors(value.toString()).whenComplete(() {
                                  setState(() {});
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Buildings',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedWork,
                              items: works.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                works.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Work',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedFloor,
                              // hint: const Text("Floor"),
                              //disabledHint: const Text("Select building first"),
                              items: floors.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedFloor = value;
                                getRooms(selectedBuilding.toString(),
                                        value.toString())
                                    .whenComplete(
                                  () {
                                    setState(() {});
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                labelText: 'Floors',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedServiceProvider,
                              items: serviceProviders.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedServiceProvider = value;
                                getServiceProvider().whenComplete(
                                  () {
                                    setState(() {});
                                  },
                                );
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Service Provider',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField(
                            items: rooms.map((String option) {
                              return DropdownMenuItem(
                                  value: option, child: Text(option));
                            }).toList(),
                            onChanged: (value) async {
                              selectedRoom = value;
                              getAssets(selectedBuilding ?? '',
                                      selectedFloor ?? '', value.toString())
                                  .whenComplete(
                                () {
                                  setState(() {});
                                },
                              );
                            },
                            decoration: InputDecoration(
                                labelText: 'Rooms',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedStatus,
                              items: status.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                status.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedAsset,
                              items: assets.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Assets',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        filterTickets(_selectDate ?? '').whenComplete(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => displayReport(
                                        ticketList: ticketList,
                                        ticketData: filterData,
                                      )));
                        });
                      },
                      child: const Text('Apply Filter'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future getBuildings() async {
    QuerySnapshot buildingQuery =
        await FirebaseFirestore.instance.collection("buildingNumbers").get();
    buildings = buildingQuery.docs.map((e) => e.id).toList();
    await getWorks();
    print(buildings);
  }

  Future getFloors(String selectedBuilding) async {
    if (selectedBuilding.isNotEmpty) {
      QuerySnapshot floorQuery = await FirebaseFirestore.instance
          .collection("buildingNumbers")
          .doc(selectedBuilding)
          .collection("floorNumbers")
          .get();
      floors = floorQuery.docs.map((e) => e.id).toList();
    }
  }

  Future getRooms(String selectedBuilding, String selectedFloor) async {
    if (selectedBuilding.isNotEmpty && selectedFloor.isNotEmpty) {
      QuerySnapshot roomQuery = await FirebaseFirestore.instance
          .collection("buildingNumbers")
          .doc(selectedBuilding)
          .collection("floorNumbers")
          .doc(selectedFloor)
          .collection("roomNumbers")
          .get();
      if (roomQuery.docs.isNotEmpty) {
        rooms = roomQuery.docs.map((e) => e.id).toList();
      }
    }
  }

  Future getAssets(String selectedBuilding, String selectedFloor,
      String selectedRoom) async {
    if (selectedBuilding.isNotEmpty &&
        selectedFloor.isNotEmpty &&
        selectedRoom.isNotEmpty) {
      QuerySnapshot assetQuery = await FirebaseFirestore.instance
          .collection("buildingNumbers")
          .doc(selectedBuilding)
          .collection("floorNumbers")
          .doc(selectedFloor)
          .collection("roomNumbers")
          .doc(selectedRoom)
          .collection("assets")
          .get();
      if (assetQuery.docs.isNotEmpty) {
        assets = assetQuery.docs.map((e) => e.id).toList();
      }
    }
  }

  Future getWorks() async {
    QuerySnapshot workQuery =
        await FirebaseFirestore.instance.collection("works").get();
    works = workQuery.docs.map((workData) => workData.id).toList();
  }

  Future getServiceProvider() async {
    List<String> tempData = [];
    QuerySnapshot serviceProviderQuery = await FirebaseFirestore.instance
        .collection("members")
        .where("role", isNotEqualTo: null)
        .get();
    if (serviceProviderQuery.docs.isNotEmpty) {
      serviceProviders = serviceProviderQuery.docs.map((e) => e.id).toList();
    }
    for (var i = 0; i < tempData.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("members")
          .doc(tempData[i])
          .get();
      if (documentSnapshot.data() != null) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        serviceProviders.add(data['fullName']);
      }
    }
  }

  Future<void> filterTickets(String selectedDate) async {
    try {
      String year = selectedDate.split('-')[2];
      String month = selectedDate.split('-')[1];
      String selectedMonth = DateFormat.MMM().format(
        DateTime(
          0,
          int.parse(month),
        ),
      );
      print("year - $year month - $month");

      Query query = FirebaseFirestore.instance
          .collection('raisedTickets')
          .doc(year)
          .collection('months')
          .doc(selectedMonth)
          .collection('date')
          .doc(selectedDate)
          .collection('tickets');

      if (selectedBuilding != null) {
        query = query.where('building', isEqualTo: selectedBuilding.toString());
      }
      if (selectedAsset != null && selectedBuilding != null) {
        query = query.where('asset', isEqualTo: selectedAsset.toString());
      }
      if (selectedFloor != null) {
        query = query.where('floor', isEqualTo: selectedFloor.toString());
      }
      if (selectedServiceProvider != null) {
        query = query.where('serviceProvider',
            isEqualTo: selectedServiceProvider.toString());
      }
      if (selectedRoom != null) {
        query = query.where('room', isEqualTo: selectedRoom.toString());
      }
      if (selectedStatus != null) {
        query.where('status', isEqualTo: selectedStatus.toString());
      }
      if (selectedWork != null) {
        query.where('work', isEqualTo: selectedWork.toString());
      }

      QuerySnapshot filterQuery = await query.get();
      ticketList = filterQuery.docs.map((e) => e.id).toList();

      filterData = filterQuery.docs.map((e) => e.data()).toList();
      print("FilterData : $filterData");
      print(ticketList);
    } catch (e) {
      print("Error Occured While Filtering Data");
    }
  }

  Future<void> getCalendar() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      String date = DateFormat("dd-MM-yyyy").format(selectedDate);
      _selectDate = date;
    }
  }
}

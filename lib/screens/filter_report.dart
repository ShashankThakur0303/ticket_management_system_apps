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
  List<String> asset = [];
  List<String> floors = [];
  List<String> room = [];
  List<String> work = [];
  List<String> serviceProvider = [];
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField(
                              value: selectedBuilding,
                              items: buildings.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField(
                              value: selectedAsset,
                              items: asset.map((String option) {
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField(
                              value: selectedFloor,
                              disabledHint: const Text("Select building first"),
                              items: floors.map((String option) { 
                                return DropdownMenuItem<String>( 
                                  value: option,
                                  child: Text(option),
                                ); 
                              }).toList(),
                              onChanged: (value) async {
                                floors.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Floors',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField(
                              value: selectedServiceProvider,
                              items: serviceProvider.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                serviceProvider.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Service Provider',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
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
                            value: selectedRoom,
                            items: room.map((String option) {
                              return DropdownMenuItem(
                                  value: option, child: Text(option));
                            }).toList(),
                            onChanged: (value) async {
                              room.clear();
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                labelText: 'Rooms',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField(
                              value: selectedWork,
                              items: work.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                work.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Work',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
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
    print(buildings);
  }

  Future getFloors(String selectedBuilding) async {
    QuerySnapshot floorQuery = await FirebaseFirestore.instance
        .collection("buildingNumbers")
        .doc(selectedBuilding)
        .collection("floorNumbers")
        .get();
    floors = floorQuery.docs.map((e) => e.id).toList();
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

      if (bldgController.text.isNotEmpty) {
        query = query.where('building', isEqualTo: bldgController.text.trim());
      }
      if (assetController.text.isNotEmpty && bldgController.text.isNotEmpty) {
        query = query.where('asset', isEqualTo: assetController.text.trim());
      }
      if (floorController.text.isNotEmpty) {
        query = query.where('floor', isEqualTo: floorController.text.trim());
      }
      if (serviceProviderController.text.isNotEmpty) {
        query = query.where('serviceProvider',
            isEqualTo: serviceProviderController.text.trim());
      }
      if (roomController.text.isNotEmpty) {
        query = query.where('room', isEqualTo: roomController.text.trim());
      }
      if (statusController.text.isNotEmpty) {
        query.where('status', isEqualTo: statusController.text.trim());
      }
      if (workController.text.isNotEmpty) {
        query.where('work', isEqualTo: workController.text.trim());
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

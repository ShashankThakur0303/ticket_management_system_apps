import 'package:flutter/material.dart';

class service_report2 extends StatefulWidget {
  const service_report2({super.key});

  @override
  State<service_report2> createState() => _service_report2State();
}

class _service_report2State extends State<service_report2> {
  final List<String> serviceProviders = [
    'Provider A',
    'Provider B',
    'Provider C',
    'Provider D',
  ];

  String? _selectedServiceProvider;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('service_report2')),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ticket #: 12345', // Display your ticket number here
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Status - Open',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const TextField(
                      decoration: InputDecoration(hintText: 'Work'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Building'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Floor'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Room'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Asset'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButtonFormField(
                        value: _selectedServiceProvider,
                        items: serviceProviders.map((String provider) {
                          return DropdownMenuItem(
                            value: provider,
                            child: Text(provider),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedServiceProvider = value.toString();
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Service Provider',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Remark:-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Remarks',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Picture'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getCurrentDate(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}

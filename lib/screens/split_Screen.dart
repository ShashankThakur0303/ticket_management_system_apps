import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Homescreen.dart';
import 'package:ticket_management_system/Service%20Provider/service_home.dart';

class spliScreen extends StatefulWidget {
  const spliScreen({super.key});

  @override
  State<spliScreen> createState() => _spliScreenState();
}

class _spliScreenState extends State<spliScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                userID: '',
                              )));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.purple,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        "Proceed as\n    User",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homeservice()));
                },
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.deepPurple,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.webhook_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            'Proceed as Service\n           Provider',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

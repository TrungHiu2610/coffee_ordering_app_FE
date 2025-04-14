import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoRun extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return DemoRunState();
  }
}

class DemoRunState extends State<DemoRun>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Text("Demo run")
            ],
          )
      ),
    );
  }
}
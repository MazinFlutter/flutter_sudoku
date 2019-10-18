import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InstructionsPage extends StatefulWidget {

  InstructionsPage({Key key,}) : super(key: key);

  @override
  _InstructionsPageState createState() => _InstructionsPageState();

}

class _InstructionsPageState extends State<InstructionsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instructions'),),
      body: Center(child: Text('Instruction Page')),
    );
  }
}

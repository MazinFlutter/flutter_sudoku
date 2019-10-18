import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {

  @required
  final String title ;

  @required
  final Function onPressed ;

  AnimatedButton({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin{

  List<Color> colors = <Color>[Colors.green, Colors.orange, Colors.red] ;

  double _scale;

  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() { setState(() {});});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
          scale: _scale,
          child: Container(
            width: MediaQuery.of(context).size.width/1.9,
            height: MediaQuery.of(context).size.height/12,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/24),
                  side: BorderSide(color: Colors.lightBlueAccent)
              ),
              child: Center(child: Text(widget.title,style: TextStyle(fontSize: 24.0,color: Colors.white)),),
            ),
          )
      ),
    );
  }

  void _onTapDown(TapDownDetails details) async{
    _controller.forward();
    Future.delayed( Duration(seconds: 1), (){
      widget.onPressed();
    });
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

}

import 'package:flutter/material.dart';


///A general animated button which must be provided with a name and a corresponding function.

class AnimatedButton extends StatefulWidget {

  //The text that'll be displayed in the middle of the button.
  //النص الذي سيكون موجودا في منتصف الزر.
  @required
  final String title ;

  //The function that'll be called when pressing this [AnimatedButton].
  //الدالة التي سيتم استدعاؤها عند الضغط على الزر.
  @required
  final Function onPressed ;

  AnimatedButton({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin{

  double _scale;

  AnimationController _controller;

  Duration animationDuration = Duration(milliseconds: 200) ;

  double buttonWidth ;

  double buttonHeight ;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() { setState(() {});});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _scale = 1 - _controller.value;

    buttonWidth = MediaQuery.of(context).size.width/1.9 ;

    buttonHeight = MediaQuery.of(context).size.height/12;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
          scale: _scale,
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            child: RaisedButton(
              //onPressed isn't provided because it absorb the press action from GestureDetector, and won't let the scaling animation to work properly, as onTapUp isn't triggered
              //لم توضع قيمة للدالة onPressed وذلك لكونها تتجاوب مع ضغطة المستخدم وتمنع GestureDetector من عرض تأثير تغيير الحجم بصورة صحيحة.
              shape: RoundedRectangleBorder(
                //Set as half the height so that RaisedButton Sides are half Circles.
                //قيمة انحراف حواف الزر هي نصف ارتفاع الزر، وذلك لتصبح الجوانب عبارة عن أنصاف دوائر.
                  borderRadius: BorderRadius.circular(buttonHeight/2),
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
    //This delay is put so that the animation has some time to be shown to user before navigating.
    //هذا التأخير موضوع بغرض اتاحة زمن لعرض تأثيير تغيير الحجم قبل الذهاب إلى صفحة أخرى.
    Future.delayed( Duration(seconds: 1), (){
      widget.onPressed();
    });
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

}

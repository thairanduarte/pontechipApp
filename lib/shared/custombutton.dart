import 'package:flutter/material.dart';
import 'package:potenchip/shared/text.dart';

Widget CustomButtonWidget({String text,double height,Function onPressed,BuildContext context,double width}){
  return Padding(
    padding: width == null ? EdgeInsets.only(left:MediaQuery.of(context).size.width/7.5,right:MediaQuery.of(context).size.width/7.5) : EdgeInsets.only(left:width,right:width),
    child: Container(
      height: height,
      decoration: BoxDecoration(
        gradient:LinearGradient(colors: [Colors.red[900],Colors.black26],
        begin:Alignment.topCenter,
        end: Alignment.bottomCenter 
        ),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: Colors.transparent,
        child: Center(child: CustomText(text,17),),
        onPressed:onPressed,
      ),
    ),
  );
}


Widget CustomButtonWidgetSave({String text,double height,Function onPressed,BuildContext context,double width}){
  return Padding(
    padding: EdgeInsets.all(8),
    child: Container(
      width: 150,
      height: height,
      decoration: BoxDecoration(
        gradient:LinearGradient(colors: [Colors.red[900],Colors.black26],
        begin:Alignment.topCenter,
        end: Alignment.bottomCenter 
        ),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: Colors.transparent,
        child: Center(child: CustomText(text,17),),
        onPressed:onPressed,
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potenchip/shared/const.dart';

Text CustomText(String text,double size,{FontStyle fontStyle,Color color, TextAlign align}){
  return Text(
    text, style: TextStyle(
      fontSize:size,
      fontWeight:FontWeight.bold,
      color:color != null ? color :Colors.white,
      fontStyle: fontStyle!=null ? fontStyle : FontStyle.italic,
      fontFamily: FONTFAMILY,
      
    ),
    textAlign: align == null ? TextAlign.center : align,
    maxLines: 10,
    overflow: TextOverflow.clip,
  );
}

Text CustomTextSmall(String text,double size,{FontStyle fontStyle, TextDecoration decoration}){
  return Text(
    text, style: TextStyle(
      fontSize:size,
      fontWeight:FontWeight.bold,
      color:Colors.white,
      fontStyle: FontStyle.italic,
      fontFamily: FONTFAMILY,
      decoration: decoration !=null ? decoration : TextDecoration.underline,      
    ),
    textAlign: TextAlign.center,


  );
}

  List<DropdownMenuItem<String>> convertToMenuItem(List<String> datavalues){
        List<DropdownMenuItem<String>> stateList = List<DropdownMenuItem<String>>();
    datavalues.forEach((element) {
      stateList.add(DropdownMenuItem(
          value: element.toString(),
          child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 45,
              child: Center(
                  child: Text(
                element.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )))));
    });
    return stateList;

  }

  List<DropdownMenuItem<String>> convertToMenuItemModels(List<dynamic> datavalues){
        List<DropdownMenuItem<String>> stateList = List<DropdownMenuItem<String>>();
    datavalues.forEach((element) {
      stateList.add(DropdownMenuItem(
          value: element["name"].toString(),
          child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 45,
              child: Center(
                  child: Text(
                element["name"].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )))));
    });
    return stateList;

  }
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
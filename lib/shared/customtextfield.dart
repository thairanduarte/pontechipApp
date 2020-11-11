import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomLoginTextField extends StatelessWidget {

  CustomLoginTextField({this.hint, this.prefix, this.suffix, this.obscure = false,
    this.textInputType, this.onChanged, this.enabled, this.controller,this.labelText,this.inputFormatter,this.onSubmitted,this.height,this.width
  ,this.textAlign});

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget suffix;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final bool enabled;
  final String labelText;
  final List<TextInputFormatter> inputFormatter;
  final Function(String) onSubmitted;
  final double height;
  final double width;
  final TextAlign textAlign;

    


  @override
  Widget build(BuildContext context) {

  
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(32),
        //border: Border(bottom:BorderSide(width: 1,color:Colors.grey))
      ),
      padding: prefix != null ? EdgeInsets.only(left:6) : null,
      child: Center(
        child: TextField(
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.normal
            

          ),
          controller: controller,
          obscureText: obscure,
          keyboardType: textInputType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          inputFormatters: inputFormatter != null ? inputFormatter :[WhitelistingTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 16,
              color:Colors.white70,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              
              
              
              
            ),
            
            labelText:labelText,
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: textAlign != null ? textAlign :TextAlign.start,
          
        ),
      ),
    );
  }
}




class CustomPlateTextField extends StatelessWidget {

  CustomPlateTextField({this.hint, this.prefix, this.suffix, this.obscure = false,
    this.textInputType, this.onChanged, this.enabled, this.controller,this.labelText,this.inputFormatter,this.onSubmitted,this.height,this.width
  ,this.textAlign});

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget suffix;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final bool enabled;
  final String labelText;
  final List<TextInputFormatter> inputFormatter;
  final Function(String) onSubmitted;
  final double height;
  final double width;
  final TextAlign textAlign;

    


  @override
  Widget build(BuildContext context) {

  
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5),
        //border: Border(bottom:BorderSide(width: 1,color:Colors.grey))
      ),
      padding: prefix != null ? EdgeInsets.only(left:6) : null,
      child: Center(
        child: TextField(
          style: TextStyle(
              fontSize: 23,
              color:Colors.white,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 3

          ),
          controller: controller,
          obscureText: obscure,
          keyboardType: textInputType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 23,
              color:Colors.white70,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 3
              
              
              
              
              
            ),
            
            labelText:labelText,
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: textAlign != null ? textAlign :TextAlign.start,
          
        ),
      ),
    );
  }
}




class CustomPlateMercosulTextField extends StatelessWidget {

  CustomPlateMercosulTextField({this.hint, this.prefix, this.suffix, this.obscure = false,
    this.textInputType, this.onChanged, this.enabled, this.controller,this.labelText,this.inputFormatter,this.onSubmitted,this.height,this.width
  ,this.textAlign});

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget suffix;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final bool enabled;
  final String labelText;
  final List<TextInputFormatter> inputFormatter;
  final Function(String) onSubmitted;
  final double height;
  final double width;
  final TextAlign textAlign;

    


  @override
  Widget build(BuildContext context) {

  
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5),
        //border: Border(bottom:BorderSide(width: 1,color:Colors.grey))
      ),
      padding: prefix != null ? EdgeInsets.only(left:6) : null,
      child: Center(
        child: TextField(
          style: TextStyle(
              fontSize: 23,
              color:Colors.white,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 3

          ),
          controller: controller,
          obscureText: obscure,
          keyboardType: textInputType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 23,
              color:Colors.white70,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 3
              
              
              
              
              
            ),
            
            labelText:labelText,
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: textAlign != null ? textAlign :TextAlign.start,
          
        ),
      ),
    );
  }
}




class CustomEditTextField extends StatelessWidget {

  CustomEditTextField({this.hint, this.prefix, this.suffix, this.obscure = false,
    this.textInputType, this.onChanged, this.enabled, this.controller,this.labelText,this.inputFormatter,this.onSubmitted,this.height,this.width
  ,this.textAlign});

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget suffix;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final bool enabled;
  final String labelText;
  final List<TextInputFormatter> inputFormatter;
  final Function(String) onSubmitted;
  final double height;
  final double width;
  final TextAlign textAlign;

    


  @override
  Widget build(BuildContext context) {

  
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
        //border: Border(bottom:BorderSide(width: 1,color:Colors.grey))
      ),
      padding: prefix != null ? EdgeInsets.only(left:6) : null,
      child: Center(
        child: TextField(
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.normal
            

          ),
          controller: controller,
          obscureText: obscure,
          keyboardType: textInputType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enabled: enabled,
          inputFormatters: inputFormatter != null ? inputFormatter :[WhitelistingTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 16,
              color:Colors.white70,
              fontWeight:FontWeight.bold,
              fontStyle: FontStyle.normal,
              
              
              
              
              
            ),
            
            labelText:labelText,
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: prefix,
            suffixIcon: suffix,
            
          ),
          textAlignVertical: TextAlignVertical.center,
          textAlign:TextAlign.start,
          
        ),
      ),
    );
  }
}


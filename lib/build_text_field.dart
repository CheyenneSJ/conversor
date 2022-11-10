import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController textEC;
  final Function(String) function;

  const BuildTextField({
    Key? key,
    required this.label,
    required this.prefix,
    required this.textEC,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEC,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25,
      ),
      onChanged: function,
      keyboardType: TextInputType.number,
    );
  }
}

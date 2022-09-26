import 'package:flutter/material.dart';
import 'package:countryfrapp/ui/listview_countries.dart';

void main() => runApp(
    MaterialApp(
      title: 'Weather Application',
      home: ListViewCountries(),

    )
);
Future initialization(BuildContext? context) async{
  await Future.delayed(const Duration(seconds: 3));
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:countryfrapp/model/country.dart';
import 'package:countryfrapp/utils/database_helper.dart';
import 'package:countryfrapp/ui/country_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class ListViewCountries extends StatefulWidget{
  const ListViewCountries({super.key});

  @override
  _ListViewCountriesState createState() => _ListViewCountriesState();
}

class _ListViewCountriesState extends State<ListViewCountries>{
  List<Country> items = [];
  DatabaseHelper db = DatabaseHelper();
  late Future<Weather> futureWeather;
  @override
  void initState() {
    super.initState();
    db.getAllCountries()?.then((countries){
      setState(() {
        for (var country in countries) {
          items.add(Country.fromMap(country));
        }
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'List Countries',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('List Countries'),
              centerTitle: true,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: Center(
              child: ListView.builder(
                  itemCount: items.length,
                  padding:const EdgeInsets.all(15.0),
                  itemBuilder: (context , position){
                    return Column(
                      children: <Widget>[
                        const Divider(height: 5.0,),
                        Row(
                          children: <Widget>[

                            Expanded(
                                child: ListTile(
                                  title: Text(items[position].name,
                                    style: const TextStyle(fontSize: 22.0,color: Colors.redAccent
                                    ),
                                  ),
                                  subtitle: Text('${items[position].language} - ${items[position].code} - ${items[position].longitude} - ${items[position].latitude}',
                                    style: const TextStyle(fontSize: 14.0,fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  leading: Column(
                                    children: <Widget>[
                                      const Padding(padding: EdgeInsets.all(1.0)),
                                      CircleAvatar(
                                        backgroundColor: Colors.amber,
                                        radius: 18.0,
                                        child: Text('${items[position].id}',
                                          style: const TextStyle(fontSize: 22.0,color: Colors.white
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  onTap: () => _navigateToCountryInfo(context , items[position]),
                                )
                            ),

                            IconButton(icon: const Icon(Icons.edit,color: Colors.blueAccent,),
                              onPressed: () => _navigateToCountry(context , items[position]),
                            ),

                            IconButton(icon: const Icon(Icons.delete,color: Colors.red,),
                                onPressed: () => _deleteCountry(context,items[position],position)
                            )
                          ],
                        ),
                      ],
                    );
                  }
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
              onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom,
                  child:  CountryScreen(Country('', '', '','',''))),

              ),
            )));
  }

  _deleteCountry(BuildContext context,Country country,int position) async{
    db.deleteCountry(country.id).then((employees){
      setState(() {
        items.removeAt(position);
      });
    });
  }


  void  _navigateToCountry(BuildContext context ,Country country)async{
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder:(context) => CountryScreen(country)),
    );

    if(result == 'update'){
      db.getAllCountries().then((countries){
        setState(() {
          items.clear();
          for (var country in countries) {
            items.add(Country.fromMap(country));
          }
        });
      });
    }
  }




  void  _navigateToCountryInfo(BuildContext context ,Country country)async{

    futureWeather = getCurrentCountryWeather(context, country);

    showDialog(
        context: context,
        barrierDismissible: false, // disables popup to close if tapped outside popup (need a button to close)
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("title",),
            content: Text("Weather Temperature is $Text(futureWeather)",),
            //buttons?

          );
        }
    );


  }



  void _createNewCountry(BuildContext context) async{
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder:(context) => CountryScreen(
          Country('', '', '','',''))),
    );

    if(result == 'save'){
      db.getAllCountries().then((countries){
        setState(() {
          items.clear();
          for (var country in countries) {
            items.add(Country.fromMap(country));
          }
        });
      });
    }
  }

  getCurrentCountryWeather(BuildContext context, Country country) async {
    var client = http.Client();
    var uri =
        'https://api.open-meteo.com/v1/forecast?latitude=${country.latitude}&longitude=${country.longitude} ';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

class Weather {
  final int temperature;
  final int weathercode;
  final int windspeed;
  final int winddirection;

  const Weather({
    required this.temperature,
    required this.weathercode,
    required this.windspeed,
    required this.winddirection
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current_weather'].temperature,
      weathercode: json['current_weather'].weathercode,
      windspeed: json['current_weather'].windspeed,
      winddirection: json['current_weather'].winddirection,
    );
  }
import 'package:page_transition/page_transition.dart';
class CountryScreen extends StatefulWidget{
  final Country country;
  CountryScreen(this.country);
  @override
  _CountryScreenState createState() => new _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen>{
  DatabaseHelper db = new DatabaseHelper();

  late TextEditingController _nameController;
  late TextEditingController _languageController;
  late TextEditingController _codeController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;

  @override
  void initState() {
    db.initDB();
    super.initState();

    _languageController = new TextEditingController(text: widget.country.language);
    _nameController = new TextEditingController(text: widget.country.name);
    _codeController = new TextEditingController(text: widget.country.code);
    _longitudeController = new TextEditingController(text: widget.country.longitude);
    _latitudeController = new TextEditingController(text: widget.country.latitude);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Country') ,

      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              controller: _languageController ,
              decoration: InputDecoration(labelText: 'Language'),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code'),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            Padding(padding: EdgeInsets.all(5.0)),

            ElevatedButton(
              child: (widget.country.id != null) ? Text(
                'update',style: TextStyle(color: Colors.white),) : Text('save',style: TextStyle(color: Colors.white),) ,
              //color: Colors.deepPurpleAccent,
              onPressed: () {



                if(widget.country.id != null){
                  db.updateCountry(Country.fromMap({
                    'id' : widget.country.id,
                    'name' : _nameController.text,
                    'language' : _languageController.text,
                    'code' :  _codeController.text,
                    'longitude' : _longitudeController.text,
                    'latitude' : _latitudeController.text
                  })).then((_){
                    Navigator.pop(context, 'update');
                  }) ;
                } else {
                  db.saveCountry(Country(
                      _nameController.text,
                      _languageController.text,
                      _codeController.text,
                      _longitudeController.text,
                      _latitudeController.text
                  )).then((_){
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),

          ],
        ),
      ),
    );
  }

}
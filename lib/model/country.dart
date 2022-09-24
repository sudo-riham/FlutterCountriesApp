class Country{
  late String name ;
  late String language ;
  late String code;
  late String longitude;
  late String latitude ;
  int? id;

  Country(this.name, this.language, this.code, this.longitude, this.latitude);


  Country.map(dynamic object){
    this.name = object['name'];
    this.language = object['language'];
    this.code = object['code'];
    this.longitude = object['longitude'];
    this.latitude = object['latitude'];
    this.id = object['id'];
  }

  String get _name => name;
  String get _language => language;
  String get _code => code;
  String get _longitude => longitude;
  String get _latitude => latitude;
  int? get _id => id;


  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['name'] = _name;
    map['language'] = _language;
    map['code'] = _code;
    map['longitude'] =_longitude;
    map['latitude'] = _latitude;

    return map;
  }

  Country.fromMap(Map<String, dynamic>map){
    this.name = map['name'];
    this.language = map['language'];
    this.code = map['code'];
    this.longitude = map['longitude'];
    this.latitude = map['latitude'];
    id = map['id'];
  }
}
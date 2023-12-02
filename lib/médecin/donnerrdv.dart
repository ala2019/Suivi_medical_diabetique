import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String nom ;
String prenom ;
class donnerrdv extends StatefulWidget {

String index ;
int idmed ;
 donnerrdv({this.index,this.idmed});
  @override
  _donnerrdvState createState() => _donnerrdvState(index,idmed);
}

class _donnerrdvState extends State<donnerrdv> {

   String index ;
   int idmed ;

  _donnerrdvState(this.index,this.idmed);
  
   TextEditingController daterdv = TextEditingController();
   TextEditingController timerdv = TextEditingController();

   @override
  void initState() {
    super.initState();
    _loadCounter() ;
     getrdv().then((value) {
      setState(() {
        rdv = value;
      });
    });

  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      
      nom = (prefs.getString('nommedecin') ?? "");
      prenom = (prefs.getString('prenommedecin') ?? "");
      
    });
  }


  
  final _formKey = GlobalKey<FormState>();

   DateTime currentDate = DateTime.now();
    DateTime _date = new DateTime.now();
      TimeOfDay _time = new TimeOfDay.now();
      Duration initialtimer = new Duration();
      
      TimeOfDay _timePicked;
     
    
    Future<Null> _selectedTime(BuildContext context) async {
    _timePicked = await showTimePicker(
        context: context,
        initialTime: _time);

    if (_timePicked != null) {
      setState(() {
        _time =  _timePicked;
        timerdv.text = _time.format(context)  ;

      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
      
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate ?? currentDate;
        var date = DateTime.parse(currentDate.toString());
        var formattedDate = "${date.year}-${date.month}-${date.day}";
        daterdv.text= formattedDate.toString() ;
        
      });
  }



   Future<String> donnerrdv() async {
    String rp;

    //DateTime date = DateTime.tryParse(daterdv.text.toString()) ;
   
     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/donnerrdv.php",
        body: {
          "idmed" : idmed.toString() ,
          "index" : index.toString() ,

           "date" :  daterdv.text.toString(),
           "time" : timerdv.text.toString() ,
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
        rp = json.decode(response.body.toString()) ;
        
          });
          Fluttertoast.showToast(
                     msg: "rendez vous envoyé",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
          return rp ;
        
       
        
         
    }  

  }
    List rdv=[];
    Future <List> getrdv() async {
      List jsonResponse1 =[];
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : idmed.toString() ,  
        });
  if (response.statusCode == 200) {
    jsonResponse1 = json.decode(response.body);
        print(jsonResponse1) ;
    return jsonResponse1 ; 
  } else {
    throw Exception('Unexpected error occured!');
  }
}
 
 Future<String> addnot() async {
    String rp;
    String title = ("Dr "+nom+" "+prenom) ;
    String datee = daterdv.text;
    String timee= timerdv.text ;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : ("Votre médecin a pris un rendez-vous pour vous a $datee $timee").toString() ,

           "date" : DateFormat("yyyy-MM-dd").format(DateTime.now()).toString() ,
           "heure" : DateFormat("hh:mm:ss").format(DateTime.now()).toString() ,
           "index" : index.toString() , 
           "idmed" : idmed.toString(),
           "sender" : idmed.toString()
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });  
          return rp ;  
    } 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Donner rendez vous'),
        ),
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 30, bottom: 30),
                child: Form(
               // autovalidate: true,
                key: _formKey,
            child: ListView(
              children: <Widget>[
               
               
                Container(
                 padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
                  child: TextFormField(
                    readOnly: true,

                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                        controller: daterdv,
                    //obscureText: true,
                    onTap: (){_selectDate(context) ;
                      
                     },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      labelText: 'date de rendez-vous',
                    ),
                  ),
                ),
                Container(
                 padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                  child: TextFormField(
                    readOnly: true,

                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                        controller: timerdv,
                    //obscureText: true,
                    onTap: (){_selectedTime(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(),
                      labelText: 'heure de rendez-vous',
                    ),
                  ),
                ),
                  
               
                
                
                  //showImage(),
                
                   SizedBox(height: 10),
           
                   SizedBox(height: 10),
                   SizedBox(height: 10),
           
                   SizedBox(height: 10),
                Container(
                  //padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 10),
                  height: 50,
                  //width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                    color: Colors.white, // Border Color
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(
                            7.0) //                 <--- border radius here
                        ),
                  ),
                  child: FlatButton(
                    onPressed:(){
                      bool test= false ;
                      
                      DateTime date = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(daterdv.text+" "+timerdv.text+":00")  ;
                     //print(date);
                     for (var i=0 ; i<rdv.length ; i++){
                       if(rdv[i]['statuts']=="donne" || rdv[i]['statuts']=="modifié" || rdv[i]['statuts']=="accepté"){
                      DateTime date2 = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(rdv[i]['date_rdv']+" "+rdv[i]['time_rdv']) ;
                      
                      print(date);
                      print(date2);
                     if (date.difference(date2).inMinutes==0){
                       
                       test = true ;
                       
                     }
                     }
                     }
                     if ( test== true){
                        Fluttertoast.showToast(
                     msg: "vous avez un rendez-vous dans cette date",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.grey,
                        
                     );
                     }
                     else {

                       donnerrdv();
                       addnot();
                     }

                    } ,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Valider',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    /*color: Colors.purple,*/
                  ),
                ),

             
                
                
              ],
            )
            )
    ));
  }
}
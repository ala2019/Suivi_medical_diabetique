import 'package:flutter/material.dart' ;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

int idmed ;
int num_d ;
String index ;
String nomprenompt ;

class type1 extends StatefulWidget {
  @override
  _type1State createState() => _type1State();
}

class _type1State extends State<type1> {


  TextEditingController test = TextEditingController();
  TextEditingController datetest = TextEditingController();
  TextEditingController timetest = TextEditingController();
  TextEditingController note = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //var myFormat = DateFormat('d-MM-yyyy');
  //
  //String crenau ="" ;
  
  

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
        timetest.text = _time.format(context)  ;

      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050) ); //DateTime.now().subtract(Duration(days: 1)));
        if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate ?? currentDate;
        var date = DateTime.parse(currentDate.toString());
        var formattedDate = "${date.day}-${date.month}-${date.year}";
        datetest.text= formattedDate.toString() ;
      });
  }
  
   int _value;
  //int _value1;
  List listItem = ['a jeun', 'avant dejeun','apres dejeun','avant diner','apres diner'];


 @override
           void initState() {
           super.initState();
            _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('id_med') ?? 0);
      num_d = (prefs.getInt('num_d') ?? 0);
      index = (prefs.getString('index') ?? '');
      nomprenompt = (prefs.getString('nomprenom') ?? '');
      
      
    });
  }





   Future<String> inscriretype1() async {
    String rp;
    String crn = listItem[_value-1].toString() ;
        int valeur = int.parse(test.text) ;

     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/analyse_type1_controllers/inscriretype1.php",
        body: {
          "num_d" : num_d.toString() ,
          "index" : index.toString() ,

           "valeur" : valeur.toString() ,
           "crenaux" : crn.toString() ,
           "date" : datetest.text.toString() , 
           "heure" : timetest.text.toString(),
           "note" : note.text.toString()
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });
          addnot();
          Fluttertoast.showToast(
                     msg: "resultat danalyse envoyée",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
        
       
        
         
    }  

  }
    Future<String> addnot() async {
    String rp;
    String title = index+"  "+nomprenompt;
    
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : "votre patient a inscrit son resultat de diabéte",

           "date" : DateFormat("yyyy-MM-dd").format(DateTime.now()).toString() ,
           "heure" : DateFormat("hh:mm:ss").format(DateTime.now()).toString() ,
           "index" : index.toString() , 
           "idmed" : idmed.toString(),
           "sender" : index.toString()
           
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
          title: Text('Analyse de Diabéte'),
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
                     validator: (value) {
                           int valeur1 = int.parse(test.text) ;
                          if (value.isEmpty ) {
                            return 'champ invalid';
                            
                          } else if (valeur1 < 50 || valeur1 > 500) {

                             return 'valeur illogique';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly],
                    controller: test,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                      labelText: 'resultat en mlg',
                    ),
                  ),
                ),
                Container(
               // padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
             
              decoration: BoxDecoration(
                // Border Color
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(
                        4.0) //                 <--- border radius here
                    ),
              ),
              child: DropdownButton(
                
                  
            
                  
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.grey,
                  ),
                  hint: Text(
                      "       Créneau                                                 "),
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text(" a jeun            "),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("  Avant dejeun"),
                      value: 2,
                    ),
                     DropdownMenuItem(
                      child: Text("  Apres dejeun"),
                      value: 3,
                    ),
                     DropdownMenuItem(
                      child: Text("  Avant diner"),
                      value: 4,
                    ),
                     DropdownMenuItem(
                      child: Text("  Apres diner"),
                      value: 5,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  }),
            ),
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
                        controller: datetest,
                    //obscureText: true,
                    onTap: (){_selectDate(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      labelText: 'date de test',
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
                        controller: timetest,
                    //obscureText: true,
                    onTap: (){_selectedTime(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(),
                      labelText: 'heure de test',
                    ),
                  ),
                ),
                  
                Container(
                 // height: 150,
                 padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
                  child: TextFormField(
                     
                    
                    controller: note,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.comment),
                      border: OutlineInputBorder(),
                      labelText: 'commentaire',
                    ),
                  ),
                ),
                
                
                  //showImage(),
                
              
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
                    inscriretype1();
                    }
                  
                   ,
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
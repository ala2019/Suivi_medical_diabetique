//import 'dart:html';

import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

int idmed ;
int num_d ;
String index ;
String nomprenompatient ;



class type2 extends StatefulWidget {
  @override
  _type2State createState() => _type2State();
}

class _type2State extends State<type2> {
  TextEditingController rslt = TextEditingController();
  TextEditingController dateanalyse = TextEditingController();
  TextEditingController note = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //var myFormat = DateFormat('d-MM-yyyy');
  

    DateTime currentDate = DateTime.now();
    
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030)) ;
        if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate ?? currentDate;
        var date = DateTime.parse(currentDate.toString());
        var formattedDate = "${date.day}-${date.month}-${date.year}";
        dateanalyse.text= formattedDate.toString() ;
      });
  }
 // File _image;
  /* Future<void> getImage() async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _image = image;
  });
}*/
final picker = ImagePicker();
  // Implementing the image picker
 /* Future<void> _openImagePicker() async {
    final pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }*/


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
      nomprenompatient = (prefs.getString('nomprenom') ?? '');
      
      
    });
  }



 Future<String> inscriretype2() async {
    String rp;
    //String crn = listItem[_value-1].toString() ;
     int rsltt = int.parse(rslt.text) ;
     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/analyse_type2_controllers/inscriretype2.php",
        body: {
          "num_d" : num_d.toString() ,
          "index" : index.toString() ,

           "rslt" : rsltt.toString() ,
           
           "date" : dateanalyse.text.toString() , 
          
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
    String title = index+"  "+nomprenompatient ;
    
    
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
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                     validator: (value) {
                       int valeur1 = int.parse(rslt.text) ;
                          if (value.isEmpty  ) {
                            return 'champ invalid';
                            
                          }else if (2 > valeur1 || valeur1 >12){
                           return 'resultat illogique';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly],
                    controller: rslt,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                      labelText: 'taux_hb1Ac',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    readOnly: true,
                     validator: (value1) {
                       
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                        controller: dateanalyse,
                    //obscureText: true,
                    onTap: (){_selectDate(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      labelText: 'Date danalyse',
                    ),
                  ),
                ),
                  
                Container(
                 // height: 150,
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                     
                        
                    controller: note,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.comment),
                      border: OutlineInputBorder(),
                      labelText: 'commentaire',
                    ),
                  ),
                ),
                SizedBox(height:120),
                /* Container(
                  padding: EdgeInsets.all(10),
                 child:RaisedButton(
              child: Text("Select Image from Gallery"),
              onPressed: () {
               _openImagePicker();
              },
            ),


                ),*/
                
                  //showImage(),
                /* Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width:double.infinity,
                height: 100,
                

                color: Colors.transparent,
                child: _image != null
                    ? Image.file(_image, fit: BoxFit.cover)
                    : Text('Please select an image'),
              ),*/
              
                Container(
                  padding: EdgeInsets.all(10),
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
                    onPressed:(){ inscriretype2();
                    
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class changermdpp extends StatefulWidget {
  String index ;
  String pass ;
   changermdpp({ Key key , this.pass , this.index  }) : super(key: key);

  @override
  _changermdppState createState() => _changermdppState();
}

class _changermdppState extends State<changermdpp> {
  TextEditingController oldp = TextEditingController();
  TextEditingController newp = TextEditingController();
  TextEditingController cnewp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<String> changermdp() async {
    String rp;

    //DateTime date = DateTime.tryParse(daterdv.text.toString()) ;
   
     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/patient_controllers/changermdpp.php",
        body: {
          "index" : widget.index.toString() ,
          "password" : newp.text.toString() ,

           
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
        rp = json.decode(response.body.toString()) ;
        
          });
          Fluttertoast.showToast(
                     msg: "mot de passe changé",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
          return rp ;
        
       
        
         
    }  

  }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('changer mot de passe'),
        ),
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 70, bottom: 30),
                child: Form(
               // autovalidate: true,
                key: _formKey,
            child: ListView(
              children: <Widget>[
               
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'mot de passe invalide';
                          }
                          else if (value1 != widget.pass){
                          return 'mot de passe incorrect';
                          }
                          return null;
                        },
                    obscureText: true,
                    controller: oldp,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                      labelText: 'mot de passe actuel',
                    ),
                  ),
                ),
                 Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'nouveu mot de passe invalide';
                          }
                          return null;
                        },
                    obscureText: true,
                    controller: newp,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                      labelText: 'nouveau mot de passe',
                    ),
                  ),
                ),
                 Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                  child: TextFormField(
                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'invalid';
                          }
                          else if (newp.text != cnewp.text){
                            return 'invalid';
                          }
                          return null;
                        },
                    obscureText: true,
                    controller: cnewp,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                      labelText: 'confirmer nouveau mot de passe',
                    ),
                  ),
                ),
              
                Container(
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
                     changermdp();
                     
                     
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Changer',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    /*color: Colors.purple,*/
                  ),
                ),
                
              ],
            ))));
  }
}
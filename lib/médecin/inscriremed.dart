import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class inscriremed extends StatefulWidget {
  @override
  _inscriremedState createState() => _inscriremedState();
}

class _inscriremedState extends State<inscriremed> {

   final _formKey = GlobalKey<FormState>();
   TextEditingController motdepasse = TextEditingController();
  TextEditingController cmotdepasse = TextEditingController();
  TextEditingController cin = TextEditingController();
  TextEditingController username = TextEditingController();

   Future<String> inscriremed() async {
    String rp;
   
     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/medecin_controllers/inscriremed.php",
        body: {
          "cin" : cin.text.toString() ,
          "username" : username.text.toString() ,

           "motdepasse" : motdepasse.text.toString() ,
          
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
          print(rp) ;
          });

          if (rp=="true"){

          Fluttertoast.showToast(
                     msg: " inscription avec succées",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
                     Navigator.of(context).pop();
          } 
           else if (rp=='inscrit') {
            Fluttertoast.showToast(
                     msg: " vous avez déja inscrit",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.blueGrey,

                     );

          }
          else  {
            Fluttertoast.showToast(
                     msg: " probleme dinscrire",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.redAccent,

                     );

          }
        

        return rp ;

        
       
        
         
    }  
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     appBar: AppBar(
          title: Text('Inscrire'),
        ),

      body:  Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 25, bottom: 10),
            child: Form(
               // autovalidate: true,
                key: _formKey,
                child: Column(
                  
                  children: <Widget>[
                    Container(
                     padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 30, bottom: 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'numéro de cin invalid';
                          }
                          return null;
                        },
                        controller: cin,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(),
                          labelText: 'numéro de cin',
                        ),
                      ),
                    ),
                    Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 30, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'username invalid';
                          }
                          return null;
                        },
                        //obscureText: true,
                        controller: username,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.security),
                          border: OutlineInputBorder(),
                          labelText: 'username',
                        ),
                      ),
                    ),
                    Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 30, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'mot de passe invalid';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: motdepasse,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.security),
                          border: OutlineInputBorder(),
                          labelText: 'mot de passe',
                        ),
                      ),
                    ),
                    Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 30, bottom: 30),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'confirmer mot de passe vide';
                          } else if(motdepasse.text!=cmotdepasse.text){
                            return 'confirmer mot de passe invalid';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: cmotdepasse,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.security),
                          border: OutlineInputBorder(),
                          labelText: ' confirmer mot de passe',
                        ),
                      ),
                    ),
                   
                    Container(
                      height: 50,
                      width: 340,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                        color: Colors.white, // Border Color
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(7.0) //                 <--- border radius here
                            ),
                      ),
                      child: FlatButton(
                        onPressed: inscriremed
                          

                        ,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Inscrire',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        /*color: Colors.purple,*/
                      ),
                    ),
                   
                  ],
                ))),
      
    );
  }
}
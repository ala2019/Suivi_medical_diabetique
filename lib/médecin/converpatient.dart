import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MSG {
  final String id;
  final String contenu ;
  
  final String sender;
  final String date;
  final String time ; 
  final String index ;
  final String idmedecin ;

  MSG({this.id, this.contenu , this.sender,this.date,this.time,this.index,this.idmedecin});

  factory MSG.fromJson(Map<String, dynamic> json) {
    return MSG(
      id: json['idmsg'],
      contenu:json['contenu'] ,
      sender: json['sender'],
      date:json['datemsg'],
      time:json['heuremsg'],
      index:json['patient_index'],
      idmedecin:json['medecin_idmedecin']
    );
  }
}

class converpatient extends StatefulWidget {
  String indexpt ;
 int idmed ;
 String nom ;
 converpatient({this.indexpt,this.idmed,this.nom}) ;
  @override
  _converpatientState createState() => _converpatientState(indexpt,idmed,nom);
}

class _converpatientState extends State<converpatient> {
 String indexpt ;
 int idmed ;
 String nom ;
  _converpatientState(this.indexpt, this.idmed,this.nom);
  Future <List<MSG>> getmsg() async {

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/msg_controllers/msg.php', body: {
           "idmed" : idmed.toString() ,
           "index" : indexpt.toString()
           
        });
  if (response.statusCode == 200) {
    
    print(response.body);
    List jsonResponse = json.decode(response.body);
    print(jsonResponse) ;
    print (idmed) ;
    print(indexpt) ;
    //print(DateFormat('HH:mm').format(DateTime.now()));
      return jsonResponse.map((data) => new MSG.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}


  TextEditingController msgController = TextEditingController();
    ScrollController controller = new ScrollController();

    
         Future <List<MSG>> futureData;


 


   @override
           void initState() {
           super.initState();
            //_loadCounter();
            print(idmed);
            setState(() {
              futureData = getmsg(); 
            });
            
           
  }




  Future<String> addmsg() async {
    String rp;
   
     
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/msg_controllers/addmsg.php",
        body: {
          "idmed" : idmed.toString() ,
          "index" : indexpt.toString() ,

           "contenu" : msgController.text.toString() ,
           "sender" : idmed.toString() ,
           "date" : DateFormat('yyyy-MM-dd').format(DateTime.now()).toString() ,
           "time" :  DateFormat('HH:mm').format(DateTime.now()).toString()
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });
        
       
        
         
      

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      futureData = getmsg();
    });
    return  Scaffold(
          appBar: AppBar(
             iconTheme: IconThemeData(
            color: Colors.blueAccent, //change your color here
            ),
            backgroundColor: Colors.white,
            //automaticallyImplyLeading: false,
              title: Text(nom,style: TextStyle(color: Colors.blueAccent)),
              centerTitle: true,
              actions: [
              
               
               IconButton(
                 
              onPressed: () => getmsg() /*controller.jumpTo(controller.position.maxScrollExtent)*/,
             /*msgController.clear()*/
             icon: Icon(Icons.videocam , color: Colors.blueAccent,size: 30,),
             ),
             SizedBox(width: 10),

              ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                
                Expanded(
                child : FutureBuilder <List<MSG>>(
             //stream: futureData,
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                futureData = getmsg() ;
                List<MSG> data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  //
                 
                   
                  return Container(
                 padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                 child: Align(
                 alignment: (data[index].sender == indexpt.toString()?Alignment.topLeft:Alignment.topRight),
                   child: Container(
                 decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (data[index].sender  == indexpt.toString()?Colors.grey.shade200:Colors.blue[200]),
              ),
              padding: EdgeInsets.all(16),
              child: Text(data[index].contenu, style: TextStyle(fontSize: 15),),
                           ),
                          ),
                       );
                       
                       

                 
                }
              );
              
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return Center (child :CircularProgressIndicator());
            },
          ),


           


                ),
                
                
                  Container( alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(
                            7.0) //                 <--- border radius here
                        ),

                  ),
                  child : TextFormField(
                     validator: (value) {
                          if (value.isEmpty) {
                            return 'taper votre message svp';
                          }
                          return null;
                        },
                    controller: msgController,
                    decoration: InputDecoration(
                      //prefixIcon: Icon(Icons.person),
                      suffixIcon: IconButton(
                          onPressed: () { 
                            if (msgController.text.isNotEmpty){ 
                            setState(() {
                              
                            addmsg() ;
                            futureData = getmsg() ;
                          
                            
                            });
                            setState(() {
                               controller.animateTo(
                            0.0,
                                curve: Curves.easeOut,
                               duration: const Duration(milliseconds: 10),
                                  );
                              controller.jumpTo(controller.position.maxScrollExtent);
                            msgController.clear() ;
                          
                            });}
                           
                            controller.jumpTo(controller.position.maxScrollExtent);
                            
                          
                          },
                         /*msgController.clear()*/
                          icon: Icon(Icons.send,color: Colors.blueAccent,),
                           ),
                      border: OutlineInputBorder(
                       borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                          ), 


                      ),
                      labelText: 'taper votre message',
                      //filled: true,
                    ),
                  ),
                  
                  )
              ],
          ),
      );
  }
}
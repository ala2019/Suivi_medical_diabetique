import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
int idmed ;
class notmedecin extends StatefulWidget {
  @override
  _notmedecinState createState() => _notmedecinState();
}

class _notmedecinState extends State<notmedecin> {

   @override
  void initState() {
    super.initState();
    _loadCounter();
    
    
  }

   _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('idmed') ?? '');
      
      
    });
  }
   Future<List> getnotifications() async {
    List rp1=[] ;
    List rp=[] ;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/getnotmedecin.php",
        body: {
         
           
          "idmed" : idmed.toString() ,
        }
       // headers: {"Accept": "application/json"}
        );
          rp1 = json.decode(response.body) ;
          
          print (rp1);
         return rp1.reversed.toList() ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         automaticallyImplyLeading: false,
          title: Text('Notifications'),
        ),
      body:Center(
          child: FutureBuilder <List>(
            future: getnotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                
                
                  return Container(
                  decoration: BoxDecoration( //                    <-- BoxDecoration
                  border: Border(bottom: BorderSide(width: 1,color: Colors.blueAccent)),
                  ),
                   child:
                  ListTile(
                    dense:true,
                    minLeadingWidth: 1,
                    
                    //tileColor: Colors.grey,
                    contentPadding: EdgeInsets.only(right: 6.0, left: 3.0),
                    isThreeLine: true,
                    leading: Icon(Icons.notifications,color: Colors.blueAccent,),
                    title : Text(data[index]['title'].toString()),
                    subtitle: Text(data[index]['contenue'].toString()),
                    trailing: /*Text(data[index]['datenot'].toString()+" "+data[index]['heurenot']),*/
                     Column(

                children: <Widget>[
                  Text(data[index]['datenot'].toString(),style: TextStyle(fontSize: 10),),
                  Text(data[index]['heurenot'],style: TextStyle(fontSize: 10),),
                  
                ],
              ), 
                  ));
                   
                  
                 }

                   
                
              );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),));
  }
}
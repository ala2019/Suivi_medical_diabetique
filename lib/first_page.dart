import 'package:flutter/material.dart';
import 'package:suivi_medical/m%C3%A9decin/login_m%C3%A9decin.dart';
import 'package:suivi_medical/patient/login_patient.dart';

class firstpage extends StatefulWidget {
  @override
  _firstpageState createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  String valuechoose;
  String valuechoose2;
  int _value;
  int _value1;
  List listItem = ['Français', 'عربية'];
  List listItem2 = ['Patient', 'Médecin'];
  next() {
    if (_value1 == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login_patient()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginmedecin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30, bottom: 0),
        
        
          child :SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container (
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30, bottom: 0),
                
            child: Image(image: AssetImage('images/pm.jpg')),),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 45, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: 320,
              height: 40,
              decoration: BoxDecoration(
                // Border Color
                border: Border.all(width: 2.0, color: Colors.blueAccent),
                borderRadius: BorderRadius.all(Radius.circular(
                        4.0) //                 <--- border radius here
                    ),
              ),
              child:DropdownButton(
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.blueAccent,
                  ),
                  hint: Text(
                      "       Choisissez la langue                       "),
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("   Français"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("   عربية"),
                      value: 2,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  }),
            ),
          ),
          
          Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 30, bottom: 30),
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  // Border Color
                  border: Border.all(width: 2.0, color: Colors.blueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: DropdownButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.blueAccent,
                    ),
                    hint: Text("       Choisissez patient ou médecin     "),
                    value: _value1,
                    items: [
                      DropdownMenuItem(
                        child: Text("   Patient"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("   Médecin"),
                        value: 2,
                      ),
                    ],
                    onChanged: (value1) {
                      setState(() {
                        _value1 = value1;
                      });
                    }),
              )),
         /* Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 30, bottom: 30),
              child:*/Center(child : Container(
                height: 40,
                width: 320,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                  color: Colors.white, // Border Color
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: FlatButton(
                  onPressed: () {
                    next();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Continue',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
              ),)
        ],
      ),
    )));
  }
}

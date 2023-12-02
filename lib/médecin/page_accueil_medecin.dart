import 'package:flutter/material.dart';
import 'package:suivi_medical/m%C3%A9decin/notificationmedecin.dart';
import 'accueil_medecin.dart';

import 'profile.dart';
import 'testpt.dart';
import 'rendezvous.dart';

class page_acceuil_medecin extends StatefulWidget {
  
  @override
  _page_acceuil_medecinState createState() => _page_acceuil_medecinState();
}

class _page_acceuil_medecinState extends State<page_acceuil_medecin> {
  int _currentindex = 0;
  final List<Widget> _children = [
    acceuil_medecin(),
    rendezvous(),
    notmedecin(),
    profile()
  ];
  String txt ;

  
  
  final tabs = [
    Center(
        child: Text(
      'Accueil',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'Rendez-vous',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'notification',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'Profile',
      style: TextStyle(fontSize: 30),
    ))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedFontSize: 13,
        unselectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('home'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Rendez-vous'),
              backgroundColor: Colors.blue),
         
               BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('notification'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('profile'),
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

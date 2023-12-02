import 'package:flutter/material.dart';

class conseils extends StatefulWidget {
  const conseils({ Key key }) : super(key: key);

  @override
  _conseilsState createState() => _conseilsState();
}

class _conseilsState extends State<conseils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    appBar: AppBar(
      
      centerTitle: true,
          title: Text('Conseils'),
        ),
        body: ListView(children: [
        Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("Diabétiques : prenez soin de vos pieds" , style: TextStyle(color: Colors.blueAccent , fontWeight: FontWeight.bold , fontSize: 18) ,)
        ), Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("1. Lavez vos pieds tous les jours à l'eau tiède, savonnez et séchez bien entre les orteils pour éviter la macération et l'apparition de champignons. Evitez les bains de pieds prolongés." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
        Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("2. Appliquez chaque jour une crème hydratante ou une huile pour conserver une peau souple." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("3. En présence de corne (cors, durillon ou corne talonnière), retirez la avec une pierre ponce ; évitez les ciseaux, lames ou tout objet contondant, ainsi que les produits coricides." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
        Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("4.Coupez régulièrement les ongles, à angle droit légèrement arrondi, pas trop courts, avec des ciseaux à bouts ronds ou mieux limez avec une lime en carton." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("5.Changez de chaussettes tous les jours et préférez le coton et la laine aux matières synthétiques. Choisissez des chaussettes avec des coutures discrètes, non agressives." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("6.Faites chaque jour des mouvements d'assouplissement des pieds." , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
        Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("7.Avant d'enfiler les chaussures, vérifiez toujours qu'aucun objet ne soit malencontreusement tombé dedans (gravier, aiguille, punaise...)" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("8.Portez des chaussures fermées, à lacets, à bout large, en bon état, de préférence avec un dessus en cuir souple et une semelle relativement rigide. Changez de chaussures un jour sur deux.)" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("9.A la maison, portez des chaussons confortables fermés.)" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
         Padding(padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 20, bottom: 0),  
        child :Text("10.Ne jamais :" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 12) ,)
        ),
        
        


        ],) ,

      
    );
  }
}
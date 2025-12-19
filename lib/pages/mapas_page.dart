import 'package:flutter/material.dart';

class MapasPage extends StatelessWidget {
   
  const MapasPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, i) =>ListTile(
         leading: Icon(Icons.map,color: Theme.of(context).primaryColor),
         title: Text('http:sdsdds'),
      )            
    );
  }
}
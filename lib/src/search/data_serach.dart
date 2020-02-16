import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSerach extends SearchDelegate{

  final peliculas = [
    'Pelicula 1',
    'Up',
    'Batman',
    'Superman'
  ];

  final peliculasRecientes = [
    'Aves de Presa',
    'Rambo 1000'
  ];

  final peliculasProvider = PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
     
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.ellipsis_search, 
        progress: transitionAnimation
      ), 
      onPressed: (){
        close(context, null);
      });
  }

  @override
  Widget buildResults(BuildContext context) {
    

  }

 @override
  Widget buildSuggestions(BuildContext context) {
    
     if(query.isEmpty) return Container();

     return FutureBuilder(
       future: peliculasProvider.seachMovieByTile(query),
       builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
         if(snapshot.hasData){
            final peliculas = snapshot.data;
            return ListView(
              children: peliculas.map((pelicula){
                  return ListTile(
                    leading: Image(image: NetworkImage(pelicula.getPosterUrl()),height: 100.0,fit: BoxFit.cover,),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context,null);
                      pelicula.uniqueId = "";
                      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                    },
                  );
              }).toList(),
            );
         }else{ 
           return Container(child: CircularProgressIndicator(),);
         }
          
       },
     );
  }
  /*
  @override
  Widget buildSuggestions(BuildContext context) {
    
    final listaSugerida = (query.isEmpty)? peliculasRecientes :
                          peliculas.where((p)=> p.toLowerCase().startsWith(query.toLowerCase()) ).toList(); 
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (BuildContext context, index){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[index]),
          onTap: (){

          },
        );
      },
    );
  }*/

}
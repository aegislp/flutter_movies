import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/search/data_serach.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movies_horizontal_widget.dart';

class HomePage extends StatelessWidget {

  final PeliculasProvider peliculasProvider = new PeliculasProvider();

  
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
      
      
      appBar: AppBar(
        title: Text('Peliculas'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: DataSerach());
            },
          )
        ],
        
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _crearTarjetas(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _crearTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        if(snapshot.hasData){
          return CardSwiper(peliculas: snapshot.data);
        }else{
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        }
        
        
      },
    );
    
  }

  _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text('Populares',style: Theme.of(context).textTheme.subhead),
          SizedBox(height: 15.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                return MoviesHorizontal(peliculas: snapshot.data,siguientePagina: peliculasProvider.getPopulares );
              }else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
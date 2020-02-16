import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:peliculas/src/models/pelicula.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/widgets/actor_horizontal_widget.dart';

class PeliculaDetalle extends StatelessWidget {

  final peliculaProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {


    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
      slivers: <Widget>[
        _createAppBar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 15.0,),
            _posterPelicula(context,pelicula),
            _detallePelicula(pelicula),
            _footerDetalle(context,pelicula),
          ])
        )

      ],
    ),
    );
  }

  Widget _createAppBar(Pelicula pelicula) {


    final bgimage = pelicula.getBackgorundrUrl();

    return SliverAppBar(
          backgroundColor:  Colors.blue,
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(pelicula.title),
            background: FadeInImage(
              placeholder: AssetImage('assets/imgs/loading.gif'), 
              image: NetworkImage(bgimage),
              fadeInDuration: Duration(milliseconds: 150),
              fit: BoxFit.cover,
            ),
          ),

        );
  }

  Widget _posterPelicula(BuildContext context, Pelicula pelicula) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
         Hero(
           tag:pelicula.uniqueId,
           child: ClipRRect(child: Image(image: NetworkImage(pelicula.getPosterUrl()),height: 150.0,),borderRadius: BorderRadius.circular(20.0),)
         ),
          SizedBox(width: 15,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,style: Theme.of(context).textTheme.title,overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle,style: Theme.of(context).textTheme.subhead,overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(),style: Theme.of(context).textTheme.subhead,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _detallePelicula(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
      child: Text(pelicula.overview,textAlign: TextAlign.justify,),
    );
  }

  Widget _footerDetalle(BuildContext context,Pelicula pelicula) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text("Reparto",style: Theme.of(context).textTheme.subhead,),
          SizedBox(height: 15.0,),
          FutureBuilder(
            future: peliculaProvider.getReparto(pelicula.id),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ActorHorizontal(actores: snapshot.data,);
              }else{
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }
          )
        ],
      ),
    );
  }
}
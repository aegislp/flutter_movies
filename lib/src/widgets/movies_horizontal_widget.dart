import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula.dart';

class MoviesHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MoviesHorizontal({this.peliculas,this.siguientePagina});

  final PageController  _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,

  );
  
  @override
  Widget build(BuildContext context) {

    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent ){
        siguientePagina();
      }
    });
    final Size _screenSize = MediaQuery.of(context).size; 

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        itemBuilder: (context,i)=> _crearTarjeta(context,peliculas[i]),
        itemCount: peliculas.length,
      ),
    );
  }

  List<Widget> _createPages(BuildContext context) {

    final List<Widget> _pages = new List();

    peliculas.forEach((pelicula){

        final card = Container(
          margin: EdgeInsets.only(right: 15.0),
          child:  Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/imgs/no-image.jpg'), 
                    image: NetworkImage(pelicula.getPosterUrl()),
                    fit: BoxFit.cover,
                    height: 160.0,
                  ),
                  
                ),
                SizedBox(height: 5.0,),
                Text(pelicula.title,style: Theme.of(context).textTheme.caption,overflow: TextOverflow.ellipsis,)
            ],
          ) ,
        );
        _pages.add(card);
    });

    return _pages; 

  }

  _crearTarjeta(BuildContext context, Pelicula pelicula) {

    pelicula.uniqueId = '${pelicula.id}-card';
    final card = Container(
          margin: EdgeInsets.only(right: 15.0),
          child:  Column(
            children: <Widget>[
                Expanded(child: Hero(
                  tag: pelicula.uniqueId,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/imgs/no-image.jpg'), 
                    image: NetworkImage(pelicula.getPosterUrl()),
                    fit: BoxFit.cover,
                    height: 160.0,
                  ),
                  
                ),
                ),),
                SizedBox(height: 5.0,),
                Text(pelicula.title,style: Theme.of(context).textTheme.caption,overflow: TextOverflow.ellipsis,)
            ],
          ) ,
        );
      
      return GestureDetector(
        child: card,
        onTap: (){
          Navigator.of(context).pushNamed('detalle',arguments: pelicula );
        },
      );
  }
}
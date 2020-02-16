import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actor.dart';
class ActorHorizontal extends StatelessWidget {
 
  List<Actor> actores ;

  ActorHorizontal({this.actores});
  @override
  Widget build(BuildContext context) {
    final screenSize =  MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.3,
      child: PageView.builder(
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),
        pageSnapping: false,
        scrollDirection: Axis.horizontal,
        itemCount: actores.length,
        itemBuilder: (BuildContext context, i){
          return _createTarjetaActor(context, actores[i]);
        },
      ),
    );
  }

  Widget _createTarjetaActor(BuildContext context, Actor actor) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              placeholder: AssetImage('assets/imgs/no-image.jpg'), 
              image: NetworkImage(actor.getProfileImage()),
              height: 120.0,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 150),
            ),
          ),
          Center(
            child:Text(actor.name,textAlign: TextAlign.center,)
          )  

        ],
      ),
    );
  }
}
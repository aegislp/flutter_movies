import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actor.dart';

import 'package:peliculas/src/models/pelicula.dart';

class PeliculasProvider{

  String _apiKey   = 'API_KEY';
  String _baseUrl  = 'api.themoviedb.org';
  String _language =  'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;
  
  void disponse(){
    _popularesStreamController?.close();
  }
  

  Future<List<Pelicula>> _procesarRespuestaGet(Uri url) async{

    final response = await http.get(url);
    final decodeData = json.decode(response.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;

  }
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

    final response = await http.post(url);
    final decodeData = json.decode(response.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;

  }
  Future<List<Pelicula>> getEnCines() async{

    final url = Uri.https(_baseUrl, '3/movie/now_playing',{
      'api_key': _apiKey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>>getPopulares() async{

    if(_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_baseUrl, '3/movie/popular',{
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final response = await _procesarRespuesta(url);
    _populares.addAll(response);

    popularesSink(_populares);
    _cargando = false;
    return response;

  }


  Future<List<Actor>> getReparto(int movieId) async{
    

    if(_cargando) return [];

    _cargando = true;

    final url = Uri.https(_baseUrl, '3/movie/${movieId.toString()}/credits',{
      'api_key': _apiKey,
    });

    final response = await http.get(url);
    final decodeData = json.decode(response.body);

    final reparto = new Reparto.fromJsonList(decodeData['cast']);
    _cargando = false;

    return reparto.lista;

  }

  Future<List<Pelicula>> seachMovieByTile(String title) async{
    
    final url = Uri.https(_baseUrl, '3/search/movie',{
     'api_key': _apiKey,
      'language': _language,
      'query': title
    });


    return await _procesarRespuestaGet(url);
  }
}
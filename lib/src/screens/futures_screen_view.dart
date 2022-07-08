import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:http/http.dart" as http;

class FuturesScreenView extends StatelessWidget {
  const FuturesScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Futures'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100,
              child: FutureBuilder(
                future: Future.delayed(Duration(seconds: 5))
                    .then((value) => true), //waitForFivSec();
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator.adaptive();
                  } else {
                    return Text(
                      'Hellooooooo',
                      style: TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                        fetchPostFromApi(), //Future.delayed(Duration(seconds: 5)).then((value) => true), //waitForFivSec()
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Text('no data');
                      }
                      else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Card(child: Text(snapshot.data![index]['title'])));
                              
                            });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future waitForFivSec() async {
    await Future.delayed(Duration(seconds: 5)).then((value) => true);
  }

  Future<List<Map<String, dynamic>>> fetchPostFromApi() async {
    final String _apiEndPoint = 'https://jsonplaceholder.typicode.com/posts';
    http.Response _response = await http.get(Uri.parse(_apiEndPoint));
    var _decodedJson =
        json.decode(_response.body); //jsonDecode(_response.body);
    List<Map<String, dynamic>> _listOfPosts =
        _decodedJson.cast<Map<String, dynamic>>();
    print(_listOfPosts[0]['id'].toString());
    return _listOfPosts;
  }
}

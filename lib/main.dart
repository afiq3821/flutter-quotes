import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes app',
      home: MainPage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.pinkAccent,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<Card> _cards = [];

  @override
  initState() {
    super.initState();
    _fetchQuotes();
  }

  void _fetchQuotes() {
    setState(() {
      _cards = [];
    });
    get('https://talaikis.com/api/quotes/').then((res) {
      if (res.statusCode == 200) {
        Iterable its = json.decode(res.body);
        List<Quote> quotes = its.map((i) => Quote.fromJson(i)).toList();
        List<Card> cards = quotes.map((q) => Card(child: ListTile(
          title: Text(q.text),
          subtitle: Text(q.author),
        ))).toList();
        setState(() {
          _cards = cards;
        });
      } else {
        throw Exception('A network error occurred!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                    'Great words from Great men',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green
                    )
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 3'),
              onTap: () {},
            )
          ],
        ),
      ),
      body: Center(
        child: _cards.length > 0 ? ListView(children: _cards) : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchQuotes();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Get new quotes',
      ),
    );
  }
}

class Quote {
  final String text;
  final String author;

  Quote({this.text, this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(text: json['quote'], author: json['author']);
  }
}

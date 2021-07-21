import 'package:flutter/material.dart';
import 'dart:convert';

import 'db.dart';

class History extends StatelessWidget {
  History({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Client>>(
          future: DBProvider.db.getAllClients(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Client client = snapshot.data[index];
                  return VeloxExpansionTile(item: client);
                },
              );
            }
            return Center(
              child: Text("No history..."),
            );
          },
        ),
      ),
    );
  }

  // Widget item(context, Client i) => Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
  //       child: Velox );
}

class VeloxExpansionTile extends StatefulWidget {
  final Client item;

  const VeloxExpansionTile({Key key, this.item}) : super(key: key);
  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<VeloxExpansionTile> {
  ValueNotifier open = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: _buildPlayerModelList()),
    );
  }

  Widget _buildPlayerModelList() {
    return ValueListenableBuilder(
      valueListenable: open,
      builder: (context, isOpen, _) => ExpansionTile(
        title: Text(
          widget.item.text,
          // style: VeloxTextStyle.light,
        ),
        onExpansionChanged: (bool i) {
          open.value = i;
        },
        children: <Widget>[
          ListTile(
            title: Text(
              widget.item.converted,
              // style: VeloxTextStyle.light,
            ),
          )
        ],
        trailing: Icon(
          isOpen ? Icons.remove : Icons.add,
          color: Colors.grey,
          size: 23.0,
        ),
      ),
    );
  }
}

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  String converted;
  String text;

  Client({
    this.converted,
    this.text,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
        converted: json["converted"],
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "converted": converted,
      };
}

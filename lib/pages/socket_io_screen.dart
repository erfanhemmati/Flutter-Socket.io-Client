import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String URI = "http://192.168.1.5:3000";

class SocketIoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SocketIoScreenState();
}

class SocketIoScreenState extends State<SocketIoScreen> {
  TextEditingController _textEditingController = new TextEditingController();
  List<ChatModel> _messages = [];
  int _userId;

  // change your url
  IO.Socket socket = IO.io('http://192.168.1.5:3000/', <String, dynamic>{
    'transports': ['websocket'],
  });

  @override
  void initState() {
    super.initState();
    _userId = new Random().nextInt(1000);

    socket.on('connect', (_) {
      print("connected to socket");
    });

    socket.on('messages', (m) {
      print('message');

      _onReceiveNewMessage(m);
    });

//    socket.on('event', (data) => print(data));

    socket.on('disconnect', (_) => print('disconnect'));

//    socket.on('messages',  (_) => _onReceiveNewMessage);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('چت'),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(color: Colors.black12),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                  child: new Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                child: new ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: new BoxDecoration(
                            color: _userId == _messages[index].id
                                ? Colors.greenAccent
                                : Colors.white),
                        child: Row(
                          children: <Widget>[
                            new Text(_messages[index].message)
                          ],
                        ),
                      );
                    }),
              )),
              new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: new Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: new Icon(Icons.insert_emoticon),
                    ),
                    Expanded(
                      child: new TextField(
                        controller: _textEditingController,
                        decoration: new InputDecoration(
                            hintText: 'تایپ کنید', border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        String msg = _textEditingController.text;
                        if (_textEditingController.text.length > 0) {
                          setState(() {

                            // socket.io
                            Map<String , dynamic> jsonData = {
                              'id' : _userId,
                              'message' : msg
                            };

                            socket.emit('send_message', jsonData);

                            _messages.add(ChatModel(id: _userId, message: msg));

                            _textEditingController.text = '';
                          });
                        }
                      },
                      icon: new Icon(Icons.send),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _onReceiveNewMessage(dynamic message) {
//    Map<dynamic> msg = json.decode(message);
//    print(message['id']);
//    Map<String, dynamic> msg = jsonDecode(message);

    print(message);
    setState(() {
      _messages.add(
          new ChatModel(
              id : message['id'],
              message: message['message']
          )
      );
    });
  }
}

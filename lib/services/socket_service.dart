// ignore_for_file: unused_field, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum StatusServidor {
  online,
  offLine,
  conectando,
}

class SocketService with ChangeNotifier {
  StatusServidor _statusServidor = StatusServidor.conectando;
  late Socket _socket;

  StatusServidor get statusServidor => _statusServidor;
  Socket get socket => _socket;

  SocketService() {
    _initConfig();
    _statusServidor = StatusServidor.online;
  }

  void _initConfig() {
    //dart client
    _socket = io(
        'http://192.168.1.84:3000/',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // disable auto-connection
            .build());

    _socket.onConnect((_) {
      _statusServidor = StatusServidor.online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _statusServidor = StatusServidor.offLine;
      notifyListeners();
    });

    /*  socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje: $payload');
    }); */
  }
}

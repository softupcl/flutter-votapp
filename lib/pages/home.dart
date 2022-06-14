// ignore_for_file: prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:votaapp/models/opciones.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Opcion> opciones = [];

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('opciones-activas', _handleOpcionesActivas);
  }

  _handleOpcionesActivas(dynamic payload) {
    opciones =
        (payload as List).map((opcion) => Opcion.fromMap(opcion)).toList();
    setState(() {});
  }

/*   @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('opciones-activas');
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Votaciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.statusServidor == StatusServidor.online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _mostrarGrafica(),
          Expanded(
            child: ListView.builder(
                itemCount: opciones.length,
                itemBuilder: (context, int index) {
                  return _OpcionTile(opciones[index]);
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: agregarOpcion,
      ),
    );
  }

  Widget _OpcionTile(Opcion opcion) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(opcion.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        socketService.socket.emit('borrar-opcion', {'id': opcion.id});
      },
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminando a ${opcion.nombre}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(opcion.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(opcion.nombre),
        trailing: Text('${opcion.votos}', style: TextStyle(fontSize: 20)),
        onTap: () {
          socketService.socket.emit('voto-opcion', {'id': opcion.id});
          setState(() {});
        },
      ),
    );
  }

  agregarOpcion() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Nueva opcion:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Agregar'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => agregarOpcionLista(textController.text),
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Nueva opción'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Agregar'),
              onPressed: () => agregarOpcionLista(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Cerrar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void agregarOpcionLista(String nombre) {
    if (nombre.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('agregar-opcion', {'nombre': nombre});
    }
    setState(() {});
    Navigator.pop(context);
  }

  Widget _mostrarGrafica() {
    Map<String, double> dataMap = {};

    opciones.forEach((opcion) {
      dataMap.putIfAbsent(opcion.nombre, () => opcion.votos.toDouble());
    });

    return PieChart(
      dataMap: dataMap,
    );
  }
}

// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:votaapp/models/opciones.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Opciones> opciones = [
    Opciones(id: '1', nombre: 'Radiohead', votos: 50),
    Opciones(id: '2', nombre: 'Metallica', votos: 10),
    Opciones(id: '3', nombre: 'Lucybell', votos: 30),
    Opciones(id: '4', nombre: 'Saiko', votos: 25),
    Opciones(id: '5', nombre: 'Muse', votos: 18),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Votaciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: opciones.length,
          itemBuilder: (context, int index) {
            return _OpcionTile(opciones[index]);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: agregarOpcion,
      ),
    );
  }

  Widget _OpcionTile(Opciones opcion) {
    return Dismissible(
      key: Key(opcion.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
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
          print(opcion.nombre);
        },
      ),
    );
  }

  agregarOpcion() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
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
      this.opciones.add(new Opciones(
          votos: 0, nombre: nombre, id: DateTime.now().toString()));
      setState(() {});
    }

    Navigator.pop(context);
  }
}

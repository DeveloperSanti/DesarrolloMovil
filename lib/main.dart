import 'package:flutter/material.dart';
import 'package:notes_crud_local_app/providers/actual_option_provider.dart';
import 'package:notes_crud_local_app/providers/db_provider.dart';
import 'package:notes_crud_local_app/providers/students_provider.dart';
import 'package:notes_crud_local_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

/**
 * 
 * 1. Instalar sqflite, path_provider, provider
 * 2. Crear la carpeta "models"
 * 3. Generar el modelo de Notes usando Quicktype.io
 * 3. Crear la carpeta "providers"
 * 4. Crear el archivo "db_provider.dart", para el manejo de la bd
 * 5. Crear la funcion initDB para crear el archivo de la base de datos
 * 6. Acceder a android studio para buscar el archivo Notes.db en la ruta generada
 * desde data/com.example.notes en "View->Tool Windos->Device Explorer"
 * 7. Ir a View->Tool Windows-> App Inspection en android studio para revisar la base de datos
 * 8. Crear metodo de creacion de registro
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DBProvider.db.database;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ActualOptionProvider()),
          ChangeNotifierProvider(create: (_) => NotesProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            initialRoute: "main",
            routes: {'main': (_) => HomeScreen()}));
  }
}

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../models/students_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Obteniendo direccion base donde se guardará la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Armamos la url donde quedará la base de datos
    final path = join(documentsDirectory.path, 'StudentsDB.db');

    //Imprimos ruta
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) => {},
      onCreate: (db, version) async {
        await db.execute('''

        CREATE TABLE students(
          id INTEGER PRIMARY KEY,
          name TEXT,
          age INTEGER,
          identifyDocument TEXT
        )

''');
      },
    );
  }

  Future<int> newStudentRaw(Student student) async {
    final String id = student.id;
    final String name = student.name;
    final int edad = student.age;

    final db =
        await database; //Recibimos instancia de base de datos para trabajar con ella

    final int res = await db.rawInsert('''

      INSERT INTO students (id, title, description) VALUES ($id, "$name", $edad, "$id")

''');
    print(res);
    return res;
  }

  Future<int> newStudent(Student student) async {
    final db = await database;

    final int res = await db.insert("students", student.toJson());

    return res;
  }

  //Obtener un registro por id
  Future<Student?> getStudentById(int id) async {
    final Database db = await database;

    //usando Query para construir la consulta, con where y argumentos posicionales (whereArgs)
    final res = await db.query('students', where: 'id = ?', whereArgs: [id]);
    print(res);
    //Preguntamos si trae algun dato. Si lo hace
    return res.isNotEmpty ? Student.fromJson(res.first) : null;
  }

  Future<List<Student>> getAllStudents() async {
    final Database? db = await database;
    final res = await db!.query('students');
    //Transformamos con la funcion map instancias de nuestro modelo. Si no existen registros, devolvemos una lista vacia
    return res.isNotEmpty
        ? res.map((student) => Student.fromJson(student)).toList()
        : [];
  }

  Future<int> updateStudent(Student student) async {
    final Database db = await database;
    //con updates, se usa el nombre de la tabla, seguido de los valores en formato de Mapa, seguido del where con parametros posicionales y los argumentos finales
    final res = await db.update('students', student.toJson(),
        where: 'id = ?', whereArgs: [student.id]);
    return res;
  }

  Future<int> deleteStudent(int id) async {
    final Database db = await database;
    final int res =
        await db.delete('students', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllStudents() async {
    final Database db = await database;
    final res = await db.rawDelete('''
      DELETE FROM students    
    ''');
    return res;
  }
}

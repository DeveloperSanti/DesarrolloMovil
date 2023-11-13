import 'package:flutter/material.dart';

import '../models/students_model.dart';
import 'db_provider.dart';

class StudentProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String createOrUpdate = 'create';
  int? id;
  String name = '';
  int age = 0;
  String identityDocument = '';

  bool _isLoading = false;
  List<Student> students = [];

  bool get isLoading => _isLoading;

  set isLoading(bool opc) {
    _isLoading = opc;
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

  addStudent() async {
    final Student student = Student(name: name, age: age, id: identityDocument);

    final int res = await DBProvider.db.newStudent(student);

    student.id = res.toString();

    students.add(student);

    notifyListeners();
  }

  loadStudents() async {
    final List<Student> students = await DBProvider.db.getAllStudents();
    //operador Spreed
    this.students = [...students];
    notifyListeners();
  }

  updateStudent() async {
    final student = Student(id: identityDocument, name: name, age: age);
    final res = await DBProvider.db.updateStudent(student);
    print("Id actualizado: $res");
    loadStudents();
  }

  deleteStudentById(int id) async {
    final res = await DBProvider.db.deleteStudent(id);
    loadStudents();
  }

  assignDataWithNote(Student student) {
    id = int.tryParse(student.id) ?? 0;
    name = student.name;
    age = student.age;
    identityDocument = student.id;
  }

  resetStudentData() {
    id = null;
    name = '';
    age = 0;
    identityDocument = '';
    createOrUpdate = 'create';
  }
}

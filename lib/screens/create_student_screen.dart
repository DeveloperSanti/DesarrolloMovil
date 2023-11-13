import 'package:flutter/material.dart';
import 'package:notes_crud_local_app/providers/actual_option_provider.dart';
import 'package:provider/provider.dart';

import '../providers/students_provider.dart';

class CreateStudentScreen extends StatelessWidget {
  const CreateStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CreateForm();
  }
}

class _CreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StudentProvider studentsProvider =
        Provider.of<StudentProvider>(context);
    final ActualOptionProvider actualOptionProvider =
        Provider.of<ActualOptionProvider>(context, listen: false);
    return Form(
      key: studentsProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: studentsProvider.name,
            decoration: const InputDecoration(
                hintText: 'Digite nombre',
                labelText: 'Nombre',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            onChanged: (value) => studentsProvider.name = value,
            validator: (value) {
              return value != '' ? null : 'El campo no debe estar vacío';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            maxLines: 10,
            autocorrect: false,
            initialValue: studentsProvider.identityDocument,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Digite documento',
              labelText: 'Documento de identidad',
            ),
            onChanged: (value) => studentsProvider.identityDocument = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number, // Campo de edad como número
            initialValue: studentsProvider.age.toString(),
            decoration: const InputDecoration(
              hintText: 'Ingrese la edad',
              labelText: 'Edad',
            ),
            onChanged: (value) {
              studentsProvider.age = int.tryParse(value) ??
                  0; // Convierte a int o usa 0 si no es válido
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El campo no puede estar vacio';
              }
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: studentsProvider.isLoading
                ? null
                : () {
                    //Quitar teclado al terminar
                    FocusScope.of(context).unfocus();

                    if (!studentsProvider.isValidForm()) return;

                    if (studentsProvider.createOrUpdate == 'create') {
                      studentsProvider.addStudent();
                    } else {
                      studentsProvider.updateStudent();
                    }
                    studentsProvider.resetStudentData();
                    studentsProvider.isLoading = false;
                    actualOptionProvider.selectedOption = 0;
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                studentsProvider.isLoading ? 'Espere' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/Attendance.dart';

class AbsenceForm extends StatefulWidget {
  @override
  _AbsenceFormState createState() => _AbsenceFormState();
}

class _AbsenceFormState extends State<AbsenceForm> {
  // Champs du formulaire
  TextEditingController nceController = TextEditingController();
  TextEditingController codMatController = TextEditingController();
  TextEditingController dateAController = TextEditingController();
  TextEditingController nhaController = TextEditingController(text: "0.0");

  // Variable pour gérer le formulaire
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulaire d'absence"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NCE
              TextFormField(
                controller: nceController,
                decoration: InputDecoration(labelText: "NCE"),
              ),

              // Matière
              TextFormField(
                controller: codMatController,
                decoration: InputDecoration(labelText: "Matière"),
              ),

              // Date
              TextFormField(
                controller: dateAController,
                decoration: InputDecoration(labelText: "Date"),
              ),

              // Nombre d'heures
              TextFormField(
                controller: nhaController,
                decoration: InputDecoration(labelText: "Nombre d'heures"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir un nombre d'heures.";
                  } else if (double.tryParse(value) == null) {
                    return "Veuillez saisir un nombre valide.";
                  }
                  return null;
                },
              ),

              // Bouton Submit
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text("Enregistrer"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Récupérer les données du formulaire
                      String nce = nceController.text;
                      String codMat = codMatController.text;
                      String dateA = dateAController.text;
                      double nha = double.parse(nhaController.text);

                      // Créer une nouvelle absence
                      Attendance attendance = Attendance(
                        nce: nce,
                        codMat: codMat,
                        dateA: DateTime.parse(dateA),
                        nha: nha,
                      );

                      // Enregistrer l'absence dans la base de données
                      // TODO: Appeler la méthode `createAttendance()` du service `AttendanceService`

                      // Afficher une notification de succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("L'absence a été créée avec succès"),
                        ),
                      );

                      // Fermer le formulaire
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

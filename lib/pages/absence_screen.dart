import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Attendance.dart';

class AbsenceScreen extends StatefulWidget {
  @override
  _AbsenceScreenState createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  // Champs du formulaire
  TextEditingController nceController = TextEditingController();
  TextEditingController codMatController = TextEditingController();
  TextEditingController dateAController = TextEditingController();
  TextEditingController nhaController = TextEditingController();

  // Objet Attendance
  Attendance attendance = Attendance(
    nce: "12345678",
    codMat: "MATH",
    dateA: DateTime.now(),
    nha: 2.0,
  );

  // Liste des étudiants
  List<dynamic> etudiants = [];

  @override
  Future<void> initState() async {
    super.initState();

    // Récupérer les données des étudiants depuis l'API
    var request = http.get(
      Uri.parse("http://localhost:8085/api/v1/etudiants"),
    );

    // Envoyer la requête
    var response = await request.timeout(Duration(seconds: 10));

    // Traiter la réponse
    if (response.statusCode == 200) {
      // Les données des étudiants ont été récupérées avec succès
      var jsonResponse = jsonDecode(response.body);
      etudiants = jsonResponse["data"];
    } else {
      // Une erreur s'est produite lors de la récupération des données des étudiants
      print("Erreur lors de la récupération des données des étudiants : ${response.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des absences"),
      ),
      body: Container(
        child: Column(
          children: [
            // Liste des étudiants
            Expanded(
              child: ListView.builder(
                itemCount: etudiants.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(etudiants[index]["nom"] +
                        " " +
                        etudiants[index]["prenom"]),
                    subtitle: Text(etudiants[index]["classe"]),
                  );
                },
              ),
            ),

            // Formulaire d'absence
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
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
                    ),

                    // Bouton Submit
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text("Enregistrer"),
                        onPressed: () async {
                          // Récupérer les données du formulaire
                          String nce = nceController.text;
                          String codMat = codMatController.text;
                          String dateA = dateAController.text;
                          double nha = double.parse(nhaController.text);

                          // Mettre à jour les propriétés de l'objet Attendance
                          attendance.nce = nce;
                          attendance.codMat = codMat;
                          attendance.dateA = DateTime.parse(dateA);
                          attendance.nha = nha;

                          try {
                            // Créer une requête POST
                            var response = await http.post(
                              Uri.parse("http://localhost:8080/api/v1/attendances"),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode(attendance),
                            ).timeout(Duration(seconds: 10));

                            // Traiter la réponse
                            if (response.statusCode == 201) {
                              // L'absence a été créée avec succès
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("L'absence a été créée avec succès"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: "Voir",
                                    onPressed: () {
                                      // ...
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // Afficher un message d'erreur en cas d'échec
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Échec de la création de l'absence"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          } catch (e) {
                            // Gérer les erreurs de connexion ou de timeout
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Erreur: $e"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

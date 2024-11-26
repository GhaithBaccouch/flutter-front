import 'package:client/models/subject_model.dart';
import 'package:client/pages/class.dart';
import 'package:client/pages/department.dart';
import 'package:client/pages/home.dart';
import 'package:client/services/subject_service.dart';
import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  Future<List<Subject>> _subjects = getAllSubjects();

  void fetchSubjects() async {
    setState(() {
      _subjects = getAllSubjects();
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coefficientController = TextEditingController();
  final TextEditingController _numberOfHoursController =
      TextEditingController();
  final TextEditingController _updateNameController = TextEditingController();
  final TextEditingController _updateDescriptionController =
      TextEditingController();
  final TextEditingController _updateCoefficientController =
      TextEditingController();
  final TextEditingController _updateNumberOfHoursController =
      TextEditingController();

  void _showUpdateDialog(Subject subject) {
    _updateNameController.text = subject.name;
    _updateDescriptionController.text = subject.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFC7DAD5),
          title: const Text('Update subject'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _updateNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: _updateDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextField(
                  controller: _updateCoefficientController,
                  decoration: const InputDecoration(
                    labelText: 'Coefficient',
                  ),
                ),
                TextField(
                  controller: _updateNumberOfHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Number of hours',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final Subject subject = Subject(
                  name: _updateNameController.text,
                  description: _updateDescriptionController.text,
                  coefficient: double.parse(
                      _updateCoefficientController.text.toString()),
                  numberOfHours:
                      int.parse(_updateNumberOfHoursController.text.toString()),
                );

                updateSubject(subject);
                Navigator.pop(context);
                SnackBar snackBar = SnackBar(
                  content: Text('${_updateNameController.text} updated'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                fetchSubjects();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF84a59d),
      appBar: AppBar(
        title: const Text(
          'ISET NABEUL',
          style: TextStyle(
            color: Color(0xFF004CFF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF004CFF),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF004CFF),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text('Manage students'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              title: const Text('Manage classes'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ClassPage()));
              },
            ),
            ListTile(
              title: const Text('Manage departments'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DepartmentPage()));
              },
            ),
            ListTile(
              title: const Text('Manage subjects'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubjectPage()));
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage subjects',
                style: TextStyle(
                  color: Color(0xFF004CFF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFFC7DAD5),
                            title: const Text('Add subject'),
                            content: SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                    ),
                                  ),
                                  TextField(
                                    controller: _coefficientController,
                                    decoration: const InputDecoration(
                                      labelText: 'Coefficient',
                                    ),
                                  ),
                                  TextField(
                                    controller: _numberOfHoursController,
                                    decoration: const InputDecoration(
                                      labelText: 'Number of hours',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final Subject subject = Subject(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    coefficient: double.parse(
                                        _coefficientController.text.toString()),
                                    numberOfHours: int.parse(
                                        _numberOfHoursController.text
                                            .toString()),
                                  );
                                  createSubject(subject);
                                  Navigator.pop(context);
                                  SnackBar snackBar = SnackBar(
                                    content:
                                        Text('${_nameController.text} added'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  fetchSubjects();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Add subject'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      fetchSubjects();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Subject>>(
                future: _subjects,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].name.toString()),
                          subtitle: Text(
                              snapshot.data![index].description.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showUpdateDialog(snapshot.data![index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteSubject(snapshot.data![index].id!);
                                  SnackBar snackBar = SnackBar(
                                    content: Text(
                                        '${snapshot.data![index].name} deleted'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  fetchSubjects();
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

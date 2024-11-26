import 'package:client/models/class_model.dart';
import 'package:client/models/department_model.dart';
import 'package:client/models/subject_model.dart';
import 'package:client/pages/absence_screen.dart';
import 'package:client/pages/class_students.dart';
import 'package:client/pages/department.dart';
import 'package:client/pages/home.dart';
import 'package:client/pages/subject.dart';
import 'package:client/services/class_service.dart';
import 'package:client/services/department_service.dart';
import 'package:client/services/subject_service.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  Future<List<Class>> _classes = getAllClasses();
  Future<List<Department>> _departments = getDepartments();
  List<Subject> _subjects = [];
  Department? _selectedDepartment;
  List<Subject>? _selectedSubjects;

  void fetchClasses() {
    setState(() {
      _classes = getAllClasses();
      _departments = getDepartments();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClasses();
    getAllSubjects().then((value) {
      setState(() {
        _subjects = value;
      });
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberOfStudentsController =
      TextEditingController();

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

            ListTile(
              title: Text('Manage absence'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AbsenceScreen(),
                  ),
                );
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
                'Manage classes',
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
                            title: const Text('Add class'),
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
                                    controller: _numberOfStudentsController,
                                    decoration: const InputDecoration(
                                      labelText: 'Number of students',
                                    ),
                                  ),
                                  FutureBuilder<List<Department>>(
                                    future: _departments,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Department',
                                          ),
                                          value: _selectedDepartment,
                                          onChanged: (Department? value) {
                                            setState(() {
                                              _selectedDepartment = value;
                                            });
                                            TextField(
                                    controller: _numberOfStudentsController,
                                    decoration: const InputDecoration(
                                      labelText: 'Subjects',
                                    ),
                                  );
                                          },
                                          
                                          items: snapshot.data!
                                              .map((Department department) {
                                            return DropdownMenuItem(
                                              value: department,
                                              child: Text(department.name
                                                  .toString()
                                                  .toUpperCase()),
                                            );
                                          }).toList(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                  MultiSelectDialogField(
                                    items: _subjects
                                        .map((Subject subject) =>
                                            MultiSelectItem(
                                                subject, subject.name))
                                        .toList(),
                                    listType: MultiSelectListType.CHIP,
                                    onConfirm: (values) {
                                      _selectedSubjects = values;
                                    },
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
                                  final Class classRoom = Class(
                                    name: _nameController.text,
                                    numberOfStudents: int.parse(
                                        _numberOfStudentsController.text),
                                    department: _selectedDepartment,
                                    subjects: _selectedSubjects,
                                  );
                                  createClass(classRoom);
                                  Navigator.pop(context);
                                  SnackBar snackBar = SnackBar(
                                    content:
                                        Text('${_nameController.text} added'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  fetchClasses();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Add class'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      fetchClasses();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Class>>(
                future: _classes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClassStudentsPage(
                                        classRoom: snapshot.data![index],
                                      )),
                            );
                          },
                          title: Text(snapshot.data![index].name
                              .toString()
                              .toUpperCase()),
                          subtitle: Text(
                              'Number of students : ${snapshot.data![index].numberOfStudents}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteClass(snapshot.data![index].id!);
                                  SnackBar snackBar = SnackBar(
                                    content: Text(
                                        '${snapshot.data![index].name} deleted'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  fetchClasses();
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

import 'package:client/models/class_model.dart';
import 'package:client/models/student_model.dart';
import 'package:client/pages/class.dart';
import 'package:client/pages/department.dart';
import 'package:client/pages/sign_in.dart';
import 'package:client/pages/subject.dart';
import 'package:client/services/class_service.dart';
import 'package:client/services/student_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Student>> _students = getAllStudents();
  Future<List<Class>> _classes = getAllClasses();

  void fetchStudents() async {
    setState(() {
      _students = getAllStudents();
      _classes = getAllClasses();
    });

    List<Class> classes = await _classes;

    setState(() {
      _selectedClass = classes.isNotEmpty ? classes.first : null;
      _updatedSelectedClass = classes.isNotEmpty ? classes.first : null;
    });
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _updateFirstNameController =
      TextEditingController();
  final TextEditingController _updateLastNameController =
      TextEditingController();
  final TextEditingController _updateDateOfBirthController =
      TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Class? _selectedClass;
  Class? _updatedSelectedClass;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text =
            _selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  void addStudent(Student student) async {
    await createStudent(student);
    fetchStudents();
  }

  void _showUpdateDialog(Student student) {
    _updateFirstNameController.text = student.firstName;
    _updateLastNameController.text = student.lastName;
    _updateDateOfBirthController.text = student.dateOfBirth;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
           backgroundColor: Color(0xFFC7DAD5),
          title: const Text('Update student'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _updateFirstNameController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _updateLastNameController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _updateDateOfBirthController,
                  readOnly: true,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  onTap: () {
                    selectDate(context);
                  },
                ),
                FutureBuilder<List<Class>>(
                  future: _classes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<Class>(
                        value: _updatedSelectedClass,
                        onChanged: (Class? newValue) {
                          setState(() {
                            _updatedSelectedClass = newValue!;
                          });
                        },
                        items: snapshot.data!.map((Class value) {
                          return DropdownMenuItem<Class>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the update here using the _updatedSelectedClass and other controller values
                final updatedStudent = Student(
                  id: student.id,
                  firstName: _updateFirstNameController.text,
                  lastName: _updateLastNameController.text,
                  dateOfBirth: _updateDateOfBirthController.text,
                  classRoom: _updatedSelectedClass,
                );
                // Call your updateStudent function
                updateStudent(updatedStudent);
                fetchStudents();
                Navigator.of(context).pop();
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF004CFF),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color(0xFF004CFF),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              },
            ),
          ),
        ],
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
              onTap: () {},
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
                'Manage students',
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
                            title: const Text('Add student'),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _firstNameController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'First name'),
                                  ),
                                  TextFormField(
                                    controller: _lastNameController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Last name'),
                                  ),
                                  TextFormField(
                                    controller: _dateOfBirthController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Date of birth',
                                    ),
                                    onTap: () {
                                      selectDate(context);
                                    },
                                  ),
                                  FutureBuilder<List<Class>>(
                                    future: _classes,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField<Class>(
                                          value: _selectedClass,
                                          onChanged: (Class? newValue) {
                                            setState(() {
                                              _selectedClass = newValue!;
                                            });
                                          },
                                          items:
                                              snapshot.data!.map((Class value) {
                                            return DropdownMenuItem<Class>(
                                              value: value,
                                              child: Text(value.name),
                                            );
                                          }).toList(),
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
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final Student student = Student(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    dateOfBirth: _dateOfBirthController.text,
                                    classRoom: _selectedClass,
                                  );
                                  addStudent(student);
                                  _formKey.currentState!.reset();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Add student'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      fetchStudents();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Student>>(
                future: _students,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                          subtitle: Text(snapshot.data![index].classRoom!.name),
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
                                  deleteStudent(snapshot.data![index].id!);
                                  SnackBar snackBar = SnackBar(
                                    content: Text(
                                        '${snapshot.data![index].firstName} ${snapshot.data![index].lastName} deleted'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  fetchStudents();
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

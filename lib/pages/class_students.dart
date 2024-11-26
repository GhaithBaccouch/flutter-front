import 'package:client/models/class_model.dart';
import 'package:client/models/student_model.dart';
import 'package:client/pages/class.dart';
import 'package:client/pages/department.dart';
import 'package:client/pages/home.dart';
import 'package:client/pages/subject.dart';
import 'package:client/services/class_service.dart';
import 'package:flutter/material.dart';

class ClassStudentsPage extends StatefulWidget {
  final Class classRoom;

  const ClassStudentsPage({Key? key, required this.classRoom})
      : super(key: key);

  @override
  State<ClassStudentsPage> createState() => _ClassStudentsPageState();
}

class _ClassStudentsPageState extends State<ClassStudentsPage> {
  List<Student> _studentsByClass = [];

  Future<List<Student>> getStudents() async {
    _studentsByClass = await getStudentsByClassId(widget.classRoom.id!);
    return _studentsByClass;
  }

  int calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF84a59d),
      appBar: AppBar(
        title: Text(
          widget.classRoom.name,
          style: const TextStyle(
            color: Color(0xFF004CFF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: Builder(builder: (context) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF004CFF),
                size: 18,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ClassPage()));
              },
            ),
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Students',
                style: TextStyle(
                  color: Color(0xFF004CFF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Students list
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Student student = snapshot.data![index];
                        DateTime dob = DateTime.parse(student.dateOfBirth);
                        int age = calculateAge(dob);
                        return ListTile(
                          title:
                              Text('${student.firstName} ${student.lastName}'),
                          subtitle: Text('Age: $age'),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

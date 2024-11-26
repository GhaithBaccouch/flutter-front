import 'package:client/models/class_model.dart';
import 'package:client/models/department_model.dart';
import 'package:client/pages/department.dart';
import 'package:client/services/department_service.dart';
import 'package:flutter/material.dart';

class DepartmentClassesPage extends StatefulWidget {
  final Department department;

  const DepartmentClassesPage({super.key, required this.department});

  @override
  State<DepartmentClassesPage> createState() => _DepartmentClassesPageState();
}

class _DepartmentClassesPageState extends State<DepartmentClassesPage> {
  List<Class> _classesByDepartment = [];

  Future<List<Class>> getClasses() async {
    _classesByDepartment =
        await getClassesByDepartmentId(widget.department.id!);
    return _classesByDepartment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF84a59d),
      appBar: AppBar(
        title: Text(
          widget.department.name,
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
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepartmentPage(),
                  ),
                );
              },
            ),
          );
        }),
      ),
      body: FutureBuilder<List<Class>>(
        future: getClasses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _classesByDepartment.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_classesByDepartment[index].name),
                    subtitle: Text(
                        '${_classesByDepartment[index].numberOfStudents} students'),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

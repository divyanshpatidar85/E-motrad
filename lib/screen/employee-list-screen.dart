import 'package:att/api.dart';
import 'package:att/bloc/employee-bloc.dart';
import 'package:att/const/overlays.dart';
import 'package:att/const/theme.dart';
import 'package:att/model/user-model.dart';
import 'package:att/screen/register-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData()async{
    await GoogleSheetsApi.getAllEmployees(context:context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👔 Team Members", style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
        backgroundColor:bitterSweet.withValues(alpha:0.8),
      ),
      body: BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          if (employees.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: employee.status == 1 ? Colors.green : Colors.red,
                    child: Text(employee.username[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(employee.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${employee.email}"),
                      Text("Role: ${employee.role}"),
                      Text("Status: ${employee.status == 1 ? "Active" : "Inactive"}",
                          style: TextStyle(color: employee.status == 1 ? Colors.green : Colors.red)),
                    ],
                  ),
                  trailing: Column(
                    // ma: MainAxisSize.min,
                    children: [
                     
                      ElevatedButton(
                        onPressed: () async {
                          AnotherClass.showTransparentDialog(context);
                          await GoogleSheetsApi.updateUserStatus(email:employee.email);
                         
                          AnotherClass.hideTransparentDialog(context);
                          // context.read<EmployeeCubit>().fetchEmployees(context:context); // Refresh list
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:employee.status == 1 ? Colors.green : Colors.red ,
                        ),
                        child: Text('Change Status',style:subHeadingStyle.copyWith(fontSize:10),),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton:Container(height:50,width:120,
      child:Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
        onPressed: () async {
          AnotherClass.showTransparentDialog(context);
          await GoogleSheetsApi.getAllEmployees(context: context);
          AnotherClass.hideTransparentDialog(context);
        },
        child: const Icon(Icons.refresh),
      ),
        FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,MaterialPageRoute(builder:(context)=>RegisterScreen()));
        },
        child: const Icon(Icons.add),
      ),
        ],
      )
      ,)
    );
  }
}

import 'package:att/model/user-model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../api.dart';


class EmployeeCubit extends Cubit<List<Employee>> {
  EmployeeCubit() : super([]);

  Future<void> fetchEmployees(List<Employee> employees) async {
    try {
  
      emit(employees);
    } catch (e) {
      debugPrint("Error fetching employees: $e");
      emit([]);
    }
  }
}

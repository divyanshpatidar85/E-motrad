import 'package:bloc/bloc.dart';
import 'package:att/api.dart'; // Assuming your API functions are here

import 'package:flutter/material.dart';

import '../model/attendance-model.dart';

class AttendanceCubit extends Cubit<List<AttendanceRecord>> {
  AttendanceCubit() : super([]);

void featchAttendance(List<AttendanceRecord> record) {
    emit(record);
  }
}

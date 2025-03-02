import 'package:att/model/clock-in-model.dart';
import 'package:att/model/login_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class clockInStatus extends Cubit<ClockInStatus?> {
  clockInStatus() : super(null); 

 
  void setStatus(ClockInStatus val) {
    emit(val);
  }

  
}
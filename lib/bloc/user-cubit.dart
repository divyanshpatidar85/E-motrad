import 'package:att/model/login_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null); 

 
  void setUser(UserModel user) {
    emit(user);
  }

  // Function to clear user on logout
  void logout() {
    emit(null);
  }
}

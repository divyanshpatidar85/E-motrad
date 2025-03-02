import 'package:att/const/theme.dart';
import 'package:att/screen/login-screen.dart';
import 'package:att/screen/register-screen.dart';
import 'package:flutter/material.dart';

class TabControllerScreen extends StatefulWidget {
  const TabControllerScreen({super.key});

  @override
  State<TabControllerScreen> createState() => _TabControllerScreenState();
 
}

class _TabControllerScreenState extends State<TabControllerScreen> {
  String userIdSharedPref = '';
  @override
  void initState() {
    // updateBl('');
    super.initState();
    // loadBl();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: getHeight(context) * 0.3,
          title: Container(
            alignment: Alignment.center,
            height: 250,
            child: Image.asset(
              'assests/logo/logo.jpg',
              fit: BoxFit.contain,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Login'),
              ),
              Tab(
                child: Text('Register'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginScreen(),
            // RegisterScreen()
            Center(
              child: Text('login id:admin@gmail.com \nPasss:1234567 \nrole:Admin '))
          ],
        ),
      ),
    );
  }
}
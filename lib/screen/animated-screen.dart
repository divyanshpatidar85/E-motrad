import 'package:att/const/theme.dart';
import 'package:flutter/material.dart';

class EMotoradAnimatedScreen extends StatelessWidget {
  const EMotoradAnimatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to E Motorad",
              style: headingStyle(context).copyWith(
                color:darkPrimaryColor,
                 // White color for the heading text
                fontSize:25
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Ride the Future",
              style: subHeadingStyle.copyWith(
                // Grey color for subheading
                color: Colors.grey[400], 
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                // You can add any action here
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                decoration: BoxDecoration(
                   // Use lightPrimaryColor for the button
                  color: lightPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Get Started",
                  style: buttonTextStyle.copyWith(color: darkPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
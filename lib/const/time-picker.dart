import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Custom Time Picker that displays a wheel-style picker
class CustomTimePicker extends StatefulWidget {
  final String initialTime;
  final Function(String) onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late bool isAM;
  
  final List<String> hours = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final List<String> amPm = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();
    _parseInitialTime();
  }

  void _parseInitialTime() {
    try {
      final format = DateFormat('hh:mm a');
      final dateTime = format.parse(widget.initialTime);
      
      selectedHour = dateTime.hour % 12;
      if (selectedHour == 0) selectedHour = 12;
      
      selectedMinute = dateTime.minute;
      isAM = dateTime.hour < 12;
    } catch (e) {
      // Default values if parsing fails
      selectedHour = 9;
      selectedMinute = 0;
      isAM = true;
    }
  }

  String _formatTime() {
    int displayHour = selectedHour;
    if (displayHour == 12 && isAM) {
      displayHour = 0;
    } else if (displayHour != 12 && !isAM) {
      displayHour += 12;
    }
    
    final time = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      displayHour,
      selectedMinute,
    );
    
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                Text(
                  'Select Time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    final formattedTime = _formatTime();
                    widget.onTimeSelected(formattedTime);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours wheel
                SizedBox(
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    perspective: 0.005,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(
                      initialItem: hours.indexOf(selectedHour.toString().padLeft(2, '0')),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = int.parse(hours[index]);
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: hours.length,
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            hours[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: int.parse(hours[index]) == selectedHour
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                // Minutes wheel
                SizedBox(
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    perspective: 0.005,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(
                      initialItem: selectedMinute,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: minutes.length,
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            minutes[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: index == selectedMinute
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // AM/PM wheel
                SizedBox(
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    perspective: 0.005,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(
                      initialItem: isAM ? 0 : 1,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        isAM = index == 0;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: amPm.length,
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            amPm[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: (index == 0 && isAM) || (index == 1 && !isAM)
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
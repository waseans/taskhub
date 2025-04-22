import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final int startingWeekday = firstDayOfMonth.weekday;
    final List<Widget> dayWidgets = [];

    // Fill leading empty days
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Fill calendar days
    for (int i = 1; i <= daysInMonth; i++) {
      final isToday = i == now.day;
      final hasTasks = [3, 7, 14, 21].contains(i); // Dummy task days

      dayWidgets.add(Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isToday ? const Color(0xFFFFC727) : const Color(0xFF2A2A40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: isToday ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (hasTasks)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Calendar", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              DateFormat.yMMMM().format(now),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _DayLabel("Mon"),
                _DayLabel("Tue"),
                _DayLabel("Wed"),
                _DayLabel("Thu"),
                _DayLabel("Fri"),
                _DayLabel("Sat"),
                _DayLabel("Sun"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                children: dayWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
    );
  }
}

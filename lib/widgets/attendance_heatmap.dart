import 'package:flutter/material.dart';

class AttendanceHeatmap extends StatelessWidget {
  final List<List<int>> data; // 6 rows (time) x 7 columns (days)
  
  const AttendanceHeatmap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<String> times = ['09:00 AM', '10:00 AM', '11:00 PM', '12:00 PM', '01:00 PM', '02:00 PM'];

    return Column(
      children: [
        // Grid
        for (int i = 0; i < times.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    times[i],
                    style: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int j = 0; j < 7; j++)
                        _buildBox(data[i][j]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Days labels
        Row(
          children: [
            const SizedBox(width: 70),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days.map((d) => SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 12),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBox(int level) {
    Color color;
    switch (level) {
      case 1:
        color = const Color(0xFFC0E1E5); // Less
        break;
      case 2:
        color = const Color(0xFF66B5BF); // Half
        break;
      case 3:
        color = const Color(0xFF008394); // Full
        break;
      default:
        color = const Color(0xFFEBEBEB); // Empty/Absent
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

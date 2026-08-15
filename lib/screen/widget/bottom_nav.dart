import 'package:material_ui/material_ui.dart';
import 'package:material_3_expressive/components/navigation_bar/enums/m3e_nav_bar_enums.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:tasks/screen/calendar/calendar.dart';
import 'package:tasks/screen/home/home_screen.dart';
import 'package:tasks/screen/task/task_list.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int barIndex = 0;
  final navItem = <Widget>[HomeScreen(), Calendar(), TaskList(), TaskList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: barIndex, children: navItem),
      bottomNavigationBar: M3ENavigationBar(
        size: M3ENavBarSize.small,
        elevation: 2.0,
        backgroundColor: Colors.white,
        destinations: const [
          M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
          M3ENavigationBarDestination(
            icon: Icon(M3EIcons.calendar_month),
            label: 'Calender',
          ),
          M3ENavigationBarDestination(
            icon: Icon(M3EIcons.task_alt),
            label: 'Tasks',
          ),
          M3ENavigationBarDestination(
            icon: Icon(M3EIcons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        selectedIndex: barIndex,
        onDestinationSelected: (i) {
          print("selected: $i");
          setState(() {
            barIndex = i;
          });
        },
      ),
    );
  }
}

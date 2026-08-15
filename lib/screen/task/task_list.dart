import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/screen/widget/recent_task_card.dart';
import 'package:tasks/service/task_service.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _handleScrollNotification();
    });
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Future.wait([getIt<TaskService>().getTasks()]);
  }

  void _handleScrollNotification() {
    if (_scrollController.position.extentAfter <= 200) {
      print("near bottom");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
      appBar: AppBar(title: Text("Tasks"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignalBuilder(
                builder: (context) {
                  final tasks = getIt<TaskService>().tasks.value;
                  if (tasks!.isEmpty) {
                    return Text("No tasks found");
                  }
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed("/task", arguments: tasks[index].id);
                        },
                        child: RecentTaskCard(tasks[index]),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

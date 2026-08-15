import 'package:material_ui/material_ui.dart';
import 'package:tasks/main.dart';
import 'package:tasks/service/cache_service.dart';
import 'package:tasks/utils/feedback.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<CacheService>().putItem("user", "firstTime", false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? name = getIt<CacheService>().getItem("user", "name");
      if (name != null && mounted) {
        Navigator.pushReplacementNamed(context, "/bottombar");
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              Card(
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome To Tasks",
                        style: TextStyle(fontSize: 32, height: 2),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "How can we call you?",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Name",
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: _saveUserAndNavigate,
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUserAndNavigate() {
    final String name = nameController.text;

    if (name == "") {
      showSnackbar(context, "Please enter a name");
      return;
    }

    getIt<CacheService>().putItem("user", "name", name);

    Navigator.pushReplacementNamed(context, "/");
  }
}

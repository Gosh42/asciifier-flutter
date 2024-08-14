import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asciifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true
      ),
      home: const MyHomePage()
    );
  }
}

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  //const GeneratorPage({Key? key}) : super(key: key);
  bool darkMode = false;
  double previewFontSize = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Generator"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("imagine image being selected"),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("i don't care")
                          )
                        ]
                      )
                    )
                  )
                );
              },
              child: const Text("Select an image")
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: "Width"
                    ),
                  ),
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.link_off)),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: "Height"
                    ),
                  ),
                ),
                const SizedBox(width: 10)
              ]
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: darkMode,
              onChanged: (bool val) {
                setState(() {
                  darkMode = val;
                });
              },
              title: const Text('Reverse the Gradient...'),
              subtitle: const Text('for Dark Mode'),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "[ASCII ART HERE]",
                  border: OutlineInputBorder()
                ),
                minLines: 9,
                maxLines: 9,
              )
            ),
            Slider(
              value: previewFontSize,
              min: 0,
              max: 20,
              onChanged: (double val) {
                setState( () {
                  previewFontSize = val;
                });
              }
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("imagine ascii art being saved"),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("i don't care")
                          )
                        ]
                      )
                    )
                  )
                );
              },
              child: const Text("Save")
            ),
          ]
        )
      )
    );
  }
}

class SavesPage extends StatelessWidget{
  const SavesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved")
      ),
      body: const Center(
        child: Text('saved stuff will be here')
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (currentIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = SavesPage();
        break;
      default:
        throw UnimplementedError("How did we get here?");
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: page
          ),
          SafeArea(
            child: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.add_comment),
                  label: "Generator"
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: "Saved"
                )
              ],
              selectedIndex: currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? selectedImage;
  String previewText = '[ASCII ART HERE]';
  double previewFontSize = 4;

  bool isLinked = false;
  IconData linkIcon = Icons.link_off;

  double width = 1;
  double height = 1;

  final _textControllerWidth = TextEditingController();
  void _onWidthChanged(){
    double newWidth = max(double.parse(_textControllerWidth.text), 1);
    setState(() {
      if(isLinked){
        height *= (newWidth / width);
        String heightStr = height.round().toString();

        _textControllerHeight.removeListener(_onHeightChanged);
        _textControllerHeight.value = TextEditingValue(
          text: heightStr,
          selection: TextSelection.fromPosition(TextPosition(offset: heightStr.length))
        );
        _textControllerHeight.addListener(_onHeightChanged);
      }
      width = newWidth;
    });
  }
  final _textControllerHeight = TextEditingController();
  void _onHeightChanged(){
    double newHeight = max(double.parse(_textControllerHeight.text), 1);
    setState(() {
      if(isLinked){
        width *= (newHeight / height);
        String widthStr = width.round().toString();

        _textControllerWidth.removeListener(_onWidthChanged);
        _textControllerWidth.value = TextEditingValue(
            text: widthStr,
            selection: TextSelection.fromPosition(TextPosition(offset: widthStr.length))
        );
        _textControllerWidth.addListener(_onWidthChanged);
      }
      height = newHeight;
    });
  }



  Future _pickGalleryImage(BuildContext context) async {
    final galleryImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = galleryImage;
    });

    String funnytext;
    if(selectedImage != null) {
      funnytext = "Image selected successfully!!";
      previewText = selectedImage!.name;
    } else {
      funnytext = "Image wasn't selected.";
      previewText = '[ASCII ART HERE]';
    }

    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Notice'),
        content: SingleChildScrollView(
            child: Text(funnytext)
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('i don\'t care')
          )
        ],
      );
    }
  );
}

  @override
  void initState() {
    super.initState();

    _textControllerWidth.addListener(_onWidthChanged);
    _textControllerHeight.addListener(_onHeightChanged);
  }

  @override
  void dispose(){
    _textControllerWidth.dispose();
    _textControllerHeight.dispose();
    super.dispose();
  }

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
                _pickGalleryImage(context);
              },
              child: const Text("Select an image")
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    controller: _textControllerWidth,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Width"
                    ),
                    /*onChanged: (str){
                      double newWidth = double.parse(str);
                      setState(() {
                        if(isLinked){
                          height *= (newWidth / width);
                        }
                        width = newWidth;
                        _textControllerWidth.value = TextEditingValue(
                          text: str,
                          selection: TextSelection.fromPosition(TextPosition(offset: str.length))
                        );
                      });
                    },*/
                  ),
                ),
                IconButton(onPressed: (){
                      setState(() {
                        isLinked = !isLinked;
                        if (isLinked) {
                          linkIcon = Icons.link;
                        } else {
                          linkIcon = Icons.link_off;
                      }
                    });
                  }, icon: Icon(linkIcon)
                ),
                Flexible(
                  child: TextField(
                    controller: _textControllerHeight,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Height"
                    ),
                    /*onChanged: (str){
                      double newHeight = double.parse(str);
                      setState(() {
                        if(isLinked){
                          width *= (newHeight / height);
                        }
                        height = newHeight;
                        _textControllerHeight.value = TextEditingValue(
                          text: str,
                          selection: TextSelection.fromPosition(TextPosition(offset: str.length))
                        );
                      });
                    },*/
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
                decoration: InputDecoration(
                  hintText: previewText,
                  border: const OutlineInputBorder()
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
        page = const SavesPage();
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

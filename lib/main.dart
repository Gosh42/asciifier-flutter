import 'dart:math';
import 'dart:io';
import 'package:asciifier/asciifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img_lib;

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


class AsciiPreview extends StatefulWidget{
  final String titleText;
  final String text;
  double fontSize;

  AsciiPreview({
    Key? key,
    required this.titleText,
    required this.text,
    this.fontSize = 10
  }): super(key: key);

  @override
  State<AsciiPreview> createState() => _AsciiPreviewState();
}

class _AsciiPreviewState extends State<AsciiPreview> {
  @override
  Widget build(BuildContext buildContext) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      elevation: 5,
      child: ExpansionTile(
        title: Text(widget.titleText),
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  style: TextStyle(
                    fontSize: widget.fontSize
                  ),
                  decoration: InputDecoration(
                      hintText: widget.text,
                      border: const OutlineInputBorder()
                  ),
                  minLines: 9,
                  maxLines: 1000,
                )
            ),
            Slider(
              value: widget.fontSize,
              min: 0,
              max: 20,
              onChanged: (double val) {
                setState( () {
                  widget.fontSize = val;
                });
              }
            ),
          ],

      ),
    );
  }
}


class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  //const GeneratorPage({Key? key}) : super(key: key);
  Asciifier ascii = Asciifier();
  bool darkMode = false;

  late File placeholderImage;
  File? selectedImage;
  String previewText = '[ASCII ART HERE]';
  double previewFontSize = 4;

  bool isLinked = false;
  IconData linkIcon = Icons.link_off;

  double width = 256;
  double height = 256;

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
      selectedImage = galleryImage != null ? File(galleryImage.path) : null;
    });

    String funnytext;
    if(selectedImage != null) {
      funnytext = "Image selected successfully!!";
      debugPrint("asdsadasdasd $width");
      ascii.setupImage(img_lib.decodeImage(selectedImage!.readAsBytesSync())!, width.round(), height.round());
      ascii.makeAsciiArt();
      previewText = ascii.result;
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

  void setPlaceholderImage(String path) async{
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    placeholderImage = file;
  }


  @override
  void initState() {
    super.initState();
    _textControllerWidth.addListener(_onWidthChanged);
    _textControllerHeight.addListener(_onHeightChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) { 
      setPlaceholderImage('assets/placeholder.png');
      ascii.setupImage(img_lib.decodeImage(placeholderImage.readAsBytesSync())!, width.round(), height.round());
    });
  }

  @override
  void dispose(){
    _textControllerWidth.dispose();
    _textControllerHeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Generator"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                color: theme.colorScheme.surface,
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    _pickGalleryImage(context);
                  },
                  highlightColor: theme.colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      const Expanded(
                        child:  Text("Select an image", textAlign: TextAlign.center)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 125,
                          child: Image(
                              image: selectedImage == null
                                  ? const AssetImage('assets/placeholder.png')
                                  : FileImage(selectedImage!) as ImageProvider
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                  ascii.isGradientReversed = darkMode;
                },
                title: const Text('Reverse the Gradient...'),
                subtitle: const Text('for Dark Mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              ElevatedButton(onPressed: () {
                ascii.resizeImage(width.round(), height.round());
                ascii.makeAsciiArt();
                setState(() {
                  previewText = ascii.result;
                });
              },
                  child: const Text('Refresh')),
              AsciiPreview(titleText: 'Result', text: previewText),
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
        ),
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

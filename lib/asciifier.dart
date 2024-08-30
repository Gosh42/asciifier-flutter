import 'package:image/image.dart' as img_lib;
import 'dart:developer' as dev;

class Asciifier {
  late img_lib.Image originalImg, img;

  static const String symbolsNormal = '@&/(*,. ';
  static const String symbolsReverse = ' .,*(/&@';
  String result = '';

  bool isGradientReversed = false;

  Asciifier();

  void setupImage(img_lib.Image inputImg, int width, int height) {
    originalImg = inputImg.clone();
    img_lib.grayscale(originalImg);

    img = originalImg.clone();
    resizeImage(width, height);
    dev.log('$width -> ${img.width}');
  }

  void resizeImage(int width, int height){
    img = img_lib.copyResize(originalImg, width: width, height: height);
  }

  void makeAsciiArt(){
    List<String?> asciiRows = List<String?>.empty(growable: true);
    dev.log('start');
    String symbols = isGradientReversed ? symbolsReverse : symbolsNormal;

    // each time this threshold is passed, the ascii symbol becomes "darker"
    // used to determine which symbol to use
    int colourThreshold = (255 / symbols.length).round();

    dev.log("$colourThreshold");
    dev.log('${img.width}×${img.height}');

    for (int y = 0; y < img.height; y++) {

      String row = '';
      for (int x = 0; x < img.width; x++) {

        final img_lib.Pixel pixel = img.getPixel(x, y);
        if (pixel.a < 0) {
          row += ' ';
        } else {
          //dev.log("r: ${pixel.r}; ${pixel.r.toInt() ~/ colourThreshold}");
          row += symbols[pixel.r.toInt() ~/ colourThreshold];
        }
      }
      dev.log('$row!');
      dev.log('bye');
      asciiRows.add(row);
    }

    dev.log(asciiRows.join('\n'));
    result = asciiRows.join('\n');
  }
}
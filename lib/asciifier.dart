import 'package:image/image.dart' as img_lib;

class Asciifier {
  late img_lib.Image originalImg, img;

  static const String symbolsNormal = '@&/(*,. ';
  static const String symbolsReverse = ' .,*(/&@';
  String result = '';

  bool isGradientReversed = false;

  Asciifier(img_lib.Image inputImg, int width, int height) {
    originalImg = inputImg.clone();
    img_lib.grayscale(originalImg);

    img = originalImg.clone();
    resizeImage(width, height);
  }

  void resizeImage(int width, int height){
    img = img_lib.copyResize(originalImg, width: width, height: height);
  }

  void makeAsciiArt(){
    List<String?> asciiRows = List<String?>.empty();

    String symbols = isGradientReversed ? symbolsReverse : symbolsNormal;

    // each time this threshold is passed, the ascii symbol becomes "darker"
    // used to determine which symbol to use
    int colourThreshold = 255 ~/ symbols.length;

    for (int y = 0; y < img.height; y++) {
      String row = '';
      for (int x = 0; x < img.width; x++) {
        final img_lib.Pixel pixel = img.getPixel(x, y);

        if (pixel.a < 0) {
          row += ' ';
        } else {
          row += symbols[pixel.r.toInt() ~/ colourThreshold];
        }
      }
      asciiRows.add(row);
    }

    result = asciiRows.join('\n');
  }
}

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/services.dart';






import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';

Future<void> testReceipt(NetworkPrinter printer, int seqNum , int header , String TimeStamp) async {

print(header);

   if (header == 2){
     final ByteData data = await rootBundle.load('assets/header2.png');
     final Uint8List bytes = data.buffer.asUint8List();
     final Image? image = decodeImage(bytes);
     printer.image(image!);
   }else if (header == 3){
     final ByteData data = await rootBundle.load('assets/header3.png');
     final Uint8List bytes = data.buffer.asUint8List();
     final Image? image = decodeImage(bytes);
     printer.image(image!);
   }
   // else if (header == 3){
   //   final ByteData data = await rootBundle.load('assets/header3.png');
   //   final Uint8List bytes = data.buffer.asUint8List();
   //   final Image? image = decodeImage(bytes);
   //   printer.image(image!);
   //
   // }
   // else if (header == 4){
   //   final ByteData data = await rootBundle.load('assets/header4.png');
   //   final Uint8List bytes = data.buffer.asUint8List();
   //   final Image? image = decodeImage(bytes);
   //   printer.image(image!);
   // }
   else if (header == 5){
     final ByteData data = await rootBundle.load('assets/header5.png');
     final Uint8List bytes = data.buffer.asUint8List();
     final Image? image = decodeImage(bytes);
     printer.image(image!);
   }



  final ByteData Line_data = await rootBundle.load('assets/line.png');
  final Uint8List Line_bytes = Line_data.buffer.asUint8List();
  final Image? Line_image = decodeImage(Line_bytes);
  printer.image(Line_image!);


  printer.text(seqNum.toString(),
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size4,
        width: PosTextSize.size4,
          bold: true,

      ),
    linesAfter: 1,

  );


  printer.image(Line_image!);

  printer.row([

    PosColumn(text: TimeStamp.split('T').first, width: 6, styles: PosStyles(bold: true,align: PosAlign.center,)),
    PosColumn(text: TimeStamp.split('T').last.substring(0, 8), width: 6, styles: PosStyles(bold: true)),
  ]);
  printer.feed(2);

  final ByteData footer_data = await rootBundle.load('assets/footer.png');
  final Uint8List footer_bytes = footer_data.buffer.asUint8List();
  final Image? footer_image = decodeImage(footer_bytes);
  printer.image(footer_image!);


  printer.feed(2);
  printer.cut();
  printer.disconnect();







  // https://picsum.photos/250?image=9

  //
  // http.Response response = await http.get(
  //   Uri.parse('https://picsum.photos/250?image=9'),
  // );
  // final Uint8List bytes = response.bodyBytes;
  //
  // final Image? image = decodeImage(bytes);
  //
  //   printer.image(image!);
  //   printer.cut();
  //   printer.disconnect();

  // final Image? image = decodeImage(theimageThatC);
  //
  //
  //   printer.image(image!);
  //   printer.cut();
  //   printer.disconnect();


  //printer.disconnect();

//////////////////////////////////////////

 /*
print image from assets
 */

  //final ByteData data = await rootBundle.load('assets/logo.png');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final Image? image = decodeImage(bytes);
  // printer.image(image!);
  //
  // printer.feed(2);
  // printer.cut();



}



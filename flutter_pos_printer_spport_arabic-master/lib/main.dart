import 'dart:async';

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:printer_test_youtube/ImagestorByte.dart';
import 'package:printer_test_youtube/printer.dart';
import 'package:printer_test_youtube/services/dio_client.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../Model/BranchList.dart';
import 'Model/SequenceNoList.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Model/BranchList.dart';
import '../Model/SequenceNoList.dart';
import '../Model/SequenceNoList.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ScreenshotController screenshotController = ScreenshotController();
  String dir = Directory.current.path;
  bool _enabled = true;
  List<ResultObject> bList = [];
  List<ResultObject> b1List = [];
  // late ResultObjectS SList ;
  bool loading = false;
  String queingBranchDesc = "";
  String date = "";
  String time = "";
  int queingSequenceNo = 0;
  bool loading_S = false;
  TextEditingController printerIP = TextEditingController();
  TextEditingController password = TextEditingController();
  bool printer_enable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query();
    getIPPrinter();


  }

  getIPPrinter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String printer_IP =
    prefs.getString(" printerIP") ?? "";
    printerIP.text = printer_IP;

  }

  void _query() async {
    setState(() {
      loading = true;
    });



    final url = Uri.parse('http://192.168.0.170:5146/api/Queing/BranchList');

    try{
      var response = await get(url);
      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');

      if(response.statusCode == 200){
        setState(() {
          loading = false;


          bList = branchListFromJson(response.body).resultObject;
          b1List = bList ;






          queingBranchDesc = branchListFromJson(response.body).resultObject[0].queingBranchDesc;
          print(queingBranchDesc);

        });

      }else{
        setState(() {
          loading = false;

        });
        showAlertDialogs(context, "","حدث خلل في الاتصال");
      }



    }catch(e){
      setState(() {
        loading = false;

      });
      showAlertDialogs(context, "","حدث خلل في الاتصال");
    }






  }

  void testPrint(String printerIp , int Queing_Sequence_No ,int header, String TimeStamp) async {
    print("im inside the test print 2");
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final Printers = NetworkPrinter(paper, profile);

   try{
     final printer = await Printers.connect(printerIp, port: 9100);
     print(printer.msg);

     if(printer.msg != "Error. Printer connection timeout"){
       testReceipt(Printers, Queing_Sequence_No, header, TimeStamp);
     }




     if (printer == PosPrintResult.success) {

       setState(() {
         loading = false;
         printer_enable = true;

       });


     }
     else{
       setState(() {
         loading = false;
         printer_enable = true;

       });
       showAlertDialogs(context, "",printer.msg);
     }

    // printer.disconnect();
     // final PosPrintResult res = await printer.connect(printerIp, port: 9100);
     //
     // if (res == PosPrintResult.success) {
     //   // DEMO RECEIPT
     //   testReceipt(printer, theimageThatComesfr);
     //   print(res.msg);
     //
     // }
     // print(res.msg);
     // showAlertDialogs(context," Print result:f:",
     //     res.msg);
   }catch (e) {
     print(e);
     // do stuff
   }



  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('  printer ip قم بادخال ال',style: TextStyle(fontSize: 20),),

            content:

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 3,left: 3,top: 10),
                      child: SizedBox(
                        height: 35,

                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(


                              obscureText: false,




                              textAlign: TextAlign.right,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {

                                  printerIP.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });

                              },


                              controller:printerIP,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF7F7F7),
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                hintText: 'printer ip',
                                border: InputBorder.none,


                                //

                              )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 3,left: 3,top: 10),
                      child: SizedBox(
                        height: 35,

                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(

                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,



                              textAlign: TextAlign.right,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                              },

                              controller:password,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF7F7F7),
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                hintText: 'password',
                                border: InputBorder.none,


                                //

                              )
                          ),
                        ),
                      ),
                    )
                  ],
                )



          ,

            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('حفظ',style: TextStyle(
                  fontFamily: "Al-Jazeera-Arabic-Bold",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  color: Colors.white,
                ),),
                onPressed: () async {


                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  setState(() {

                    if(password.text == "Nablus@123"){
                      prefs.setString(" printerIP",  printerIP.text);

                      Navigator.pop(context);
                      showAlertDialogs(context, "","تم الحفظ بنجاح");

                    }else{
                      Navigator.pop(context);
                      printerIP.text = "";
                      showAlertDialogs(context, "","كلمة المرور غير صحيحة ,ادخل البيانات مجددا");
                    }


                 //   showAlertDialog(context, "","تم الحفظ بنجاح");



                  });
                },
              ),
            ],
          );
        });
  }

  //TextEditingController Printer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        backgroundColor:  Color(0xFF923731),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
        DrawerHeader(
        child: Center(
          child: Text("",style: TextStyle(
            fontFamily: "Al-Jazeera-Arabic-Bold",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0.0,
            color:  Color(0xFF923731),
          ),),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image:AssetImage('assets/nlogo.png'),
            fit: BoxFit.fitHeight,
          ))),
            ListTile(
              trailing: Icon(Icons.print),
              title:  Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "اعدادات الطابعة",

                  style: TextStyle(
                    fontFamily: "Al-Jazeera-Arabic-Bold",

                    fontSize: 20,

                    color: Colors.black,
                  ),
                ),
              ),
              onTap: () {

                _displayTextInputDialog( context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            // Align(
            //     alignment: FractionalOffset.bottomRight,
            //     // This container holds all the children that will be aligned
            //     // on the bottom and sh
            //     //
            //     // the above ListView
            //     child: Column(
            //
            //       children: <Widget>[
            //
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(
            //
            //               "قسم البرمجة والتطوير بلدية نابلس",
            //               style: TextStyle(
            //                   fontSize: 13.0,
            //                   color: Colors.black,
            //                   fontFamily:
            //                   "Al-Jazeera-Arabic-Regular"),
            //             )
            //           ],
            //         )
            //       ],
            //     )
            // )
          ],
        ),
      ),


      body:
          
      Container(


        child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: Container(
         decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
    ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,


                children: [

                  // Padding(
                  //   padding: EdgeInsets.only(right: 10),
                  //   child: InkWell(
                  //     onTap: (){
                  //       _displayTextInputDialog( context);
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //
                  //       children: [
                  //         Text(
                  //       "اعدادات الطابعة",
                  //           textAlign: TextAlign.left,
                  //           style: TextStyle(
                  //             fontFamily: "Al-Jazeera-Arabic-Bold",
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 18,
                  //             letterSpacing: 0.0,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //         Icon(Icons.settings, color: Colors.black54,),
                  //       ],
                  //     ),
                  //   ),
                  // ),


                  SizedBox(height: 20,),

                  b1List.length > 0 && loading == false?

                  ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: false,
                    padding: const EdgeInsets.only(right: 10,left: 10),
                    itemCount: b1List.length,
                    itemBuilder: (BuildContext contexts, int index) {
                      return Column(

                        children: [


                          Padding(
                            padding: EdgeInsets.only(right: 40,left: 40),
                            child: Container(
                              height: 120,

                               decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors:_enabled ? [
                                              Color(0xFF233329),
                                              Color(0xFF63D471), ]:
                                            [
                                              Color(0xFF808080),
                                              Color(0xFFBBBABA),

                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.pink.withOpacity(0.2),
                                              spreadRadius: 4,
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            )
                                          ]
                                      ),

                              width:  MediaQuery.of(context).size.width,


                              child: ElevatedButton(
                                onPressed: () async {

                                  setState(() {
                                              loading = true;
                                              printer_enable = false;

                                            });

                                              print("tap btn");
                                              int SequenceNo = b1List[index].queingBranchId;

                                            print(SequenceNo);


                                                final url = Uri.parse('http://192.168.0.170:5146/api/Queing/SequenceNo/$SequenceNo');
                                                var response = await get(url);



                                                if (response.statusCode == 200){

                                                  print("ss");



                                                    if(printerIP.text == ""){
                                                   //   showAlertDialogs(context, "","حدث خلل في ");
                                                   showAlertDialog(context, "","تاكد من اعدادات الطابعة");
                                                      setState(() {

                                                        loading = false;
                                                        printer_enable = true;

                                                      });
                                                    }else{
                                                      print(SequenceNo);

                                                      testPrint(printerIP.text,sequenceNoListFromJson(response.body).resultObject.queingSequenceNo , SequenceNo,
                                                          sequenceNoListFromJson(response.body).resultObject.timeStamp
                                                      );
                                                    }






                                                }
                                                else{
                                                  setState(() {
                                                    print("r");
                                                    loading = false;
                                                    printer_enable = true;

                                                  });
                                                  showAlertDialogs(context, "","حدث خلل في الاتصال");



                                              }


                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,

                                ),
                                 child:  Text(
                                   b1List[index].queingBranchDesc,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: "Al-Jazeera-Arabic-Bold",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 35,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),



                          //
                          // Padding(
                          //
                          //   padding: EdgeInsets.only(right: 40,left: 40),
                          //   child: Container(
                          //     height: 90,
                          //     width:  MediaQuery.of(context).size.width,
                          //
                          //
                          //
                          //     child:
                          //     InkWell(
                          //
                          //       child: Container(
                          //         height: 60,
                          //         decoration: BoxDecoration(
                          //             gradient: LinearGradient(
                          //               colors:_enabled ? [
                          //                 Color(0xFF233329),
                          //                 Color(0xFF63D471), ]:
                          //               [
                          //                 Color(0xFF808080),
                          //                 Color(0xFFBBBABA),
                          //
                          //               ],
                          //               begin: Alignment.centerLeft,
                          //               end: Alignment.centerRight,
                          //             ),
                          //             borderRadius: const BorderRadius.all(
                          //               Radius.circular(25.0),
                          //             ),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 color: Colors.pink.withOpacity(0.2),
                          //                 spreadRadius: 4,
                          //                 blurRadius: 10,
                          //                 offset: Offset(0, 3),
                          //               )
                          //             ]
                          //         ),
                          //         child: Center(
                          //           child: GestureDetector(
                          //             onTap: () {
                          //
                          //
                          //
                          //             },
                          //             child: Text(
                          //               bList[index].queingBranchDesc,
                          //               textAlign: TextAlign.left,
                          //               style: TextStyle(
                          //                 fontFamily: "Al-Jazeera-Arabic-Bold",
                          //                 fontWeight: FontWeight.w600,
                          //                 fontSize: 22,
                          //                 letterSpacing: 0.0,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       onTap: () async {
                          //
                          //         setState(() {
                          //           loading = true;
                          //           printer_enable = false;
                          //
                          //         });
                          //
                          //           print("tap btn");
                          //           int SequenceNo = bList[index].queingBranchId;
                          //
                          //         print(SequenceNo);
                          //
                          //
                          //             final url = Uri.parse('http://192.168.0.170:5146/api/Queing/SequenceNo/$SequenceNo');
                          //             var response = await get(url);
                          //
                          //
                          //
                          //             if (response.statusCode == 200){
                          //
                          //               print("ss");
                          //
                          //
                          //
                          //                 if(printerIP.text == ""){
                          //                //   showAlertDialogs(context, "","حدث خلل في ");
                          //                showAlertDialog(context, "","الرجاء ادخال Printer Ip");
                          //                   setState(() {
                          //
                          //                     loading = false;
                          //                     printer_enable = true;
                          //
                          //                   });
                          //                 }else{
                          //
                          //                   testPrint(printerIP.text,sequenceNoListFromJson(response.body).resultObject.queingSequenceNo , SequenceNo,
                          //                       sequenceNoListFromJson(response.body).resultObject.timeStamp
                          //                   );
                          //                 }
                          //
                          //
                          //
                          //
                          //
                          //
                          //             }
                          //             else{
                          //               setState(() {
                          //                 print("r");
                          //                 loading = false;
                          //                 printer_enable = true;
                          //
                          //               });
                          //               showAlertDialogs(context, "","حدث خلل في الاتصال");
                          //
                          //
                          //
                          //
                          //           }
                          //
                          //
                          //
                          //
                          //
                          //
                          //
                          //       },
                          //     ),
                          //
                          //
                          //
                          //   ),
                          // ),


                          //  SizedBox(height: 5),
                          //3rd row


                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(
                      height: 30,
                    ),
                  ): loading == true ?  Center(child: CircularProgressIndicator()): Container()




                ],
              )),
        ),
      )
      ),
    );
  }

  // Future<SequenceNoList> GetSequenceNoList(int SequenceNo) async {
  //
  //
  //
  //   final url = Uri.parse('http://192.168.0.170:5146/api/Queing/SequenceNo/$SequenceNo');
  //   var response = await get(url);
  //   print('Status code: ${response.statusCode}');
  //   print('Headers: ${response.headers}');
  //   print('Body: ${response.body}');
  //
  //
  //   if (response.statusCode == 200){
  //     return sequenceNoListFromJson(response.body);
  //   }
  //   else{
  //     return [];
  //   }
  //
  //
  //
  //
  //
  //
  //
  //
  //
  // }
  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("موافق", style: TextStyle(fontSize: 18),),
      onPressed: () {

        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content,style:TextStyle(
        fontFamily: "Al-Jazeera-Arabic-Bold",
        fontWeight: FontWeight.w600,
        fontSize: 22,
        letterSpacing: 0.0,
        color: Colors.black,
      )),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  showAlertDialogs(BuildContext context , String title , String content) {

    // set up the button
    // Widget okButton = TextButton(
    //   child: Text("موافق"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true).pop("Discard");
    //     Navigator.pop(context, 'Cancel');
    //   },
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content,style:TextStyle(
        fontFamily: "Al-Jazeera-Arabic-Bold",
        fontWeight: FontWeight.w600,
        fontSize: 22,
        letterSpacing: 0.0,
        color: Colors.black,
      )),
      actions: [

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  subOnCharecter({required String str, required int from, required int to}) {
    var runes = str.runes.toList();
    String result = '';
    for (var i = from; i < to; i++) {
      result = result + String.fromCharCode(runes[i]);
    }
    return result;
  }
}

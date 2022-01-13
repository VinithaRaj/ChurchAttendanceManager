import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:recase/recase.dart';
import 'package:attendance_church_management/api/pdf_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMC Subang Jaya Registration Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  DateTimePicker(),
    );
  }
}
class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {

  void _activateList(){
    final titlesList = <ListTile>[];
    StreamSubscription currentService = FirebaseDatabase.instance.reference().child('details').limitToLast(1).onValue.listen((event) {
      final curServicedata = new Map<String,dynamic>.from(event.snapshot.value);
      final curServicedate = curServicedata.forEach((key, value)
      {
        refid = key;
        print("i am keyyy "+key);
        final nextNameService = Map.from(value);
        final currentDateService = nextNameService['date'];
        final currentDateTitle = nextNameService['title'];
        currentLimit = nextNameService['limit'];
        collectResponses = nextNameService['collect'];
        print("I am limit"+currentLimit);
        currentTitle = "Registration for "+currentDateTitle;
        currentDate = nextNameService['time'] + ', ' + nextNameService['date'];
        setState((){
          currentChildname= currentDateService.substring(0,6)+currentDateTitle;

        });
        print(currentTitle+" i am the title");
      });
    });
    print("I am child");
    print(currentChildname);
  }
  late double _height;
  late double _width;
  GlobalKey<FormState> _key = new GlobalKey();
  var currentTitle;
  var currentDate;
  var refid;
  var currentChildname;
  bool collectResponses=true;
  var currentLimit;
  var allnames = <String>[];
  final DatabaseReference ref2 = FirebaseDatabase.instance.reference();
  //String _setTime = 'test';
  //String _setDate='test';
  late String _setTime,_setDate,name,limit;
  late String _hour, _minute, _time;
  //String name='samp';
  //String limit='samp';

  late String dateTime;
  //String doctext="No entries yet";
  var doctext = "No entries yet";
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  Widget FormUI() {
    final DatabaseReference ref2 = FirebaseDatabase.instance.reference();
    if (currentChildname != null) {
      int namecount = 1;
      StreamSubscription currentService = FirebaseDatabase.instance
          .reference()
          .child(currentChildname)
          .orderByChild("name")
          .onValue
          .listen((event) {
        final curServicedata = new Map<String, dynamic>.from(
            event.snapshot.value);
        doctext = currentTitle + " " + currentDate + "\n";
        allnames = <String>[];
        final curServicedate = curServicedata.forEach((key, value) {
          final namemap = Map.from(value);
          final eachname = namemap['name'];
          allnames.add(ReCase(eachname).titleCase);


          print(allnames.toString() + " i am the title");
        });
      });
      print("hereee");

      //print(doctext+"i am doc");
    //}

    var lencount = ref2
        .child('new')
        .onChildAdded
        .length;
    print(lencount);

    //final bytes = pdf.save();
    //final blob = html.Blob([bytes], 'application/pdf');
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              width: _width ,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ListTile(

                    title: Text("Current Service: " + currentTitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    subtitle: Text(
                        "Current Date: " + currentDate + ", Current Limit: " +
                            currentLimit,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),

                  )
                ],)),
          Container(
              padding: EdgeInsets.all(20),
              width: _width / 1.2,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Switch(value: collectResponses, onChanged:
                      (value) {
                    setState(()  {
                      collectResponses = value;
                      print(collectResponses);
                      ref2.child("details").child(refid).update({'collect':collectResponses});



                    });
                    final test = FirebaseDatabase.instance.reference().child('details').limitToLast(1).reference();
                    print(test.toString()+"i am reference");

                  },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,)
                ],
)),
          Column(
            children: <Widget>[
              Text(
                'Choose Date',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  width: _width / 1.7,
                  height: _height / 9,
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                    onSaved: (val) {
                      _setDate = val!;
                    },
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.only(top: 0.0)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Choose Time',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  width: _width / 1.7,
                  height: _height / 9,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    onSaved: (val) {
                      _setTime = val!;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),
            ],
          ),
          Column(
              children: <Widget>[
                Text(
                  'Service Title',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    width: _width / 1.7,
                    height: _height / 9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child:
                    TextFormField(
                      decoration: new InputDecoration(
                          hintText: 'Eg. Sunday Service'),
                      maxLength: 64,
                      onSaved: (val) {
                        name = val!;
                      },
                    ))
              ]

          ),
          Column(
              children: <Widget>[
                Text(
                  'Number of Slots',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    width: _width / 1.7,
                    height: _height / 9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child:
                    TextFormField(
                      //decoration: new InputDecoration(hintText: 'Eg. Sunday Service'),
                      maxLength: 64,
                      validator: (val) {
                        if (int.tryParse(val!) == null) {
                          print(val!);

                          return 'Only Numbers Allowed!';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        limit = val!;
                      },


                    ))
              ]

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _sendToDB, child: const Text("Submit"),),
              ElevatedButton(

                onPressed: () async {
                  /*ref2.child(currentChildname).once().then((snapshot) {
                    final namesjoint = new Map<String,dynamic>.from(snapshot.value);
                    print(namesjoint);

                  });*/

                  if (currentChildname != null) {
                    namecount=1;
                    var newnames = <pw.Widget>[];
                    allnames.sort((a, b) => a.toString().compareTo(b.toString()));
                    print(allnames);
                    allnames = allnames.toSet().toList();
                    allnames.forEach((element) {
                      //print(doctext);
                      //print("i am doctext");
                      doctext += namecount.toString() + ". " + element + "\n";
                      newnames.add(pw.Text(namecount.toString() + ". " + element + "\n"));
                      namecount++;
                    });
                    final pdf = pw.Document();
                    pdf.addPage(pw.MultiPage(build: (pw.Context context) => newnames));



                    /*pdf.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        build: (pw.Context context) {

                          //return pdf.save();
                          return pw.Container(
                            alignment: pw.Alignment.topLeft,
                            child: pw.Text(doctext),
                          );
                        }
                        //  ]
                        )
                    );*/

                    final bytes = await pdf.save();
                    final blob = html.Blob([bytes], 'application/pdf');
                    final url = html.Url.createObjectUrlFromBlob(blob);
                    html.window.open(url, '_blank');
                    html.Url.revokeObjectUrl(url);


                  }
                  else {
                    print("loosupayele");
                  }
                },
                child: Text('Get List of Registered Attendees'),
              ),
            ],),


          /*ElevatedButton(onPressed: (){
            final url = html.Url.createObjectUrlFromBlob(blob);
            print(doctext);
            final anchor =
            html.document.createElement('a') as html.AnchorElement
              ..href = url
              ..style.display = 'none'
              ..download = 'some_name.pdf';
            html.document.body?.children.add(anchor);
            anchor.click();
            html.document.body?.children.remove(anchor);
            html.Url.revokeObjectUrl(url);
    }
            , child: const Text("Get List"),),*/


        ]
    );
  }
  else {
    return LinearProgressIndicator();
  }
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
       // _dateController.text = DateFormat.yMd().format(selectedDate);
        _dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMMMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
    _activateList();
  }
  _sendToDB(){
    if (_key.currentState!.validate()) {
      print("hello");
      _key.currentState?.save();
      var data = {
        'date': _setDate,
        'time': _setTime,
        'limit': limit,
        'title': name,
        'collect':collectResponses,
      };
      ref2.child('details').push().set(data);
      _activateList();
      _key.currentState?.reset();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Registration Set For"),
          content: Column(children:[Text('Date:'+ _setDate),
            Text('Time: '+ _setTime),
            Text('Limit: '+ limit),
            Text('Title: '+ name),]),

          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Okay!"),
            ),
          ],
        ),

      );
    };
  }
  _getList() {

  }
  @override
  Widget build(BuildContext context) {
    
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMMMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TMC Subang Jaya Attendance Management'),
      ),
      body: new SingleChildScrollView(
          child: Container(
            child: new Form(
              child: FormUI(),
              key: _key,

            ),
          )
      ),
    );


  }
}

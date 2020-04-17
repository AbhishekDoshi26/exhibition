import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exhibition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Abhinandan Farsan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db=Firestore.instance;
  TextEditingController _packs = new TextEditingController();
  TextEditingController _cost = new TextEditingController();
  int pack=0,pr=0;

  void submit()  async{
    db.collection("Exhibition").document("exhibition").get().then((datasnapshot) {
      if(datasnapshot.exists) {
        pack = int.parse(datasnapshot.data["Packets"]);
        pr = int.parse(datasnapshot.data["Cost"]);
      }
    }).catchError((e1) => print(e1));
    print(pack);
    print(pr);
    pack=pack+int.parse(_packs.text);
    pr=pr+int.parse(_cost.text);
    var data = {
      "Packets": '$pack',
      "Cost": '$pr',
    };
    db.collection("Exhibition").document("exhibition").updateData(data).whenComplete(() {
      print("Form Added");
    }).catchError((e) => print(e));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.pages),
                labelText: 'Packets',
              ),
              controller: _packs,
            ),
            new TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.arrow_upward),
                labelText: 'Rupees',
              ),
              controller: _cost,
            ),
            new Container(
                padding: const EdgeInsets.only(top: 20, left: 110, right: 110),
                child: new MaterialButton(
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  child: Text('Submit', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  splashColor: Colors.lightBlue,
                  onPressed: submit,
                )),
          ],
        ),
      ),
    );
  }
}

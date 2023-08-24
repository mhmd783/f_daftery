import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class first extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _first();
  }
}

class _first extends State<first> {
  TextEditingController name = new TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  var name2=null;
  
  send() async {
    
    
    
    if (name.text != '') {
      SharedPreferences sh_name = await SharedPreferences.getInstance();
      // String ch_name= sh_name.getString("name")as String;
      sh_name.setString("name", name.text);
      print(name.text);
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  doit() async {
    SharedPreferences sh_name = await SharedPreferences.getInstance();
    var ch_name = sh_name.getString("name");
    setState(() {
      name2 = ch_name;
    });
    if (name2 != null) {
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  @override
  void initState() {
    super.initState();
    doit();
  }

  File? image;
  void imagecamera() async {
    var file = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = File(file!.path);
      //image = File(getimage!.path)
    });
  }

  void imagephoto() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(file!.path);
      //image = File(getimage!.path)
    });
  }

  bool ch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 150),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 150,
                  child: Image.asset(
                    "images/daftery.png",
                    height: 240,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "daftery",
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        hintText: "اسمك",
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 3))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MaterialButton(
                    //color: Color.fromARGB(255, 245, 21, 21),
                    onPressed: send,
                    child: Text(
                      "ادخل",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

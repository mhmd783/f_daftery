import 'package:daftery/db.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';

class detailes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _detailes();
  }
}

class _detailes extends State<detailes> {
  int? id;
  String? name;
  int? typeopration;
  SqlDb sqdb = new SqlDb();
  bool refresh = false;
  int get = 0;
  int pay = 0;
  int total = 0;
  String? who;
  TextEditingController mony = new TextEditingController();
  TextEditingController typeselaa = new TextEditingController();
  TextEditingController weight = new TextEditingController();
  TextEditingController number = new TextEditingController();

  bool error = true;

  List data = [];

  getid() async {
    SharedPreferences iduser = await SharedPreferences.getInstance();
    int ch_id = iduser.getInt('id') as int;

    SharedPreferences namet = await SharedPreferences.getInstance();
    String ch_name = namet.getString('namet') as String;

    setState(() {
      id = ch_id;
      name = ch_name;
    });
    getdata();
  }

  getdata() async {
    List<Map> response =
        await sqdb.readData("SELECT * FROM rel WHERE id_user=$id ORDER BY id DESC");
    setState(() {
      data = [];
      data.addAll(response);
    });

    gettotal();
  }

  gettotal() {
    total = 0;
    get = 0;
    pay = 0;
    for (int i = 0; i < data.length; i++) {
      get = get + data[i]['get'] as int;
      pay = pay + data[i]['pay'] as int;
    }
    setState(() {
      total = get - pay;

      if (total > 0) {
        who = 'true';
        sqdb.updateData(
            "UPDATE users SET mony =$total,who ='$who' WHERE id=$id");
      } else {
        total = total * -1;
        who = 'false';
        sqdb.updateData(
            "UPDATE users SET mony =$total,who ='$who' WHERE id=$id");
      }
    });
  }

  refrsh() {
    gettotal();
    getdata();
  }

  @override
  void initState() {
    getid();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(
            "$name  ",
            style: TextStyle(fontSize: 30),
          )
        ],
        title:
            who == 'false' ? Text("ليك $total جنيه") : Text("عليك $total جنيه"),
      ),
      body: Container(
        child: ListView.builder(
            shrinkWrap: false,
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Container(
                color: data[i]['get'] > 0
                    ? Color.fromARGB(255, 139, 240, 154)
                    : Color.fromARGB(255, 249, 123, 123),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text("عدد السلعه"),
                            Text("${data[i]['number']}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text("وزن السلعه"),
                            Text("${data[i]['weight']}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text("نوع السلعه"),
                            Text("${data[i]['type']}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            data[i]['get'] != 0
                                ? Text(
                                    "اخذت",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                : Text(
                                    "اعطيت",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                            data[i]['get'] != 0
                                ? Text("منه ${data[i]['get']}جنيه")
                                : Text("له ${data[i]['pay']}جنيه"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: 
                        IconButton(onPressed:()async{
                          showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              elevation: 50,
                              //icon: Icon(Icons.person),
                              title: Text("هل انت متاكد من حذف المعامله؟؟"),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: MaterialButton(
                                      onPressed: () async {
                                          int response1 = await sqdb.deleteData("DELETE FROM rel WHERE id = ${data[i]['id']}");
                                          
                                          Navigator.of(context).pop(context);
                                          setState(() {
                                            refresh = true;
                                          });
                                          refrsh();
                                        
                                      },
                                      child: Text("حذف"),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                        }, icon: Icon(Icons.delete))
                        )
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text("${data[i]['date']}"),
                            Text(":التاريخ"),
                          ],
                        )),
                        Expanded(
                            child: Row(
                          children: [
                            Text("${data[i]['time']}"),
                            Text(":الوقت")
                          ],
                        )),
                        
                      ],
                    )
                  ],
                ),
              );
            }),
      ),

      //////////////////////////////////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (ind) {
            setState(() {
              typeopration = ind;
              mony = TextEditingController(text: "");
              typeselaa = TextEditingController(text: "");
              weight = TextEditingController(text: "");
              number = TextEditingController(text: "");
            });
            print(typeopration);
            showDialog(
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    child: AlertDialog(
                      elevation: 50,
                      //icon: Icon(Icons.person),
                      title: Text("اضافه عمليه"),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: mony,
                            keyboardType: TextInputType.number,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "المبلغ",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: typeselaa,
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "نوع السلعه",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: weight,
                            keyboardType: TextInputType.number,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "وزن السلعه",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: number,
                            keyboardType: TextInputType.number,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "عدد السلعه",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                              onPressed: () async {
                                DateTime date = new DateTime.now();
                                var date1 = Jiffy(date).yMd;

                                DateTime time = new DateTime.now();
                                var time1 = Jiffy(time).jm;
                                if (mony.text != '' &&
                                    weight.text != '' &&
                                    typeselaa.text != '' &&
                                    number.text != '') {
                                  var response = await typeopration == 1
                                      ? sqdb.insertData(
                                          "INSERT INTO rel( `id_user`, `pay`, `get`, `type`, `weight`, `number`, `time`, `date`) VALUES ($id,0,${mony.text},'${typeselaa.text}', ${weight.text},${number.text},'$time1','$date1')")
                                      : sqdb.insertData(
                                          "INSERT INTO rel( `id_user`, `pay`, `get`, `type`, `weight`, `number`, `time`, `date`) VALUES ($id,${mony.text},0,'${typeselaa.text}', ${weight.text},${number.text},'$time1','$date1')");

                                  print("$response");
                                  gettotal();

                                  Navigator.of(context).pop(context);

                                  refrsh();
                                } else {}
                              },
                              child: Text("اضافه"),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_calendar), label: "اعطيت"),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_calendar), label: "اخذت"),
            
          ]),

      floatingActionButton: Row(
        children: [
          SizedBox(width: 30,),
          FloatingActionButton(
            
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('home');
            },
            child: Text("ارجع>>"),
          ),
        ],
      ),
    );
  }
}

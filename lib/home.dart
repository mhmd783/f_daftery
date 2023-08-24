import 'package:daftery/db.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _home();
  }
}

class _home extends State<home> {
  SqlDb sqdb = new SqlDb();
  List data = [];
  List data1 = [];
  bool refresh = false;
  int get = 0;
  int pay = 0;
  TextEditingController nametrad = new TextEditingController();

  int indexpage = 1;
  String name = "null";
  doit() async {
    SharedPreferences sh_name = await SharedPreferences.getInstance();
    String ch_name = sh_name.getString("name") as String;
    setState(() {
      name = ch_name;
    });
  }

  getdata() async {
    get = 0;
    List<Map> response = await sqdb.readData(
        "SELECT * FROM users WHERE who='false' OR mony=0 ORDER BY id DESC");
    data = [];

    setState(() {
      data.addAll(response);
      for (int i = 0; i < data.length; i++) {
        get = get + data[i]['mony'] as int;
      }
    });
  }

  getdata1() async {
    pay = 0;
    List<Map> response = await sqdb.readData(
        "SELECT * FROM users WHERE who='true' OR mony=0 ORDER BY id DESC");
    data1 = [];
    setState(() {
      data1.addAll(response);
      for (int i = 0; i < data1.length; i++) {
        pay = pay + data1[i]['mony'] as int;
      }
    });
  }

  refrsh() {
    if (refresh == true) {
      getdata1();
      getdata();
      refresh = false;
    }
  }

  @override
  void initState() {
    super.initState();
    doit();
    getdata();
    getdata1();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 20,
          
          title: Text("المعلم $name "),
          
          bottom:
              TabBar(indicatorColor: Color.fromARGB(255, 242, 131, 123), tabs: [
            Tab(child: Text("$pay عليك")),
            Tab(child: Text("$get ليك")),
          ]),
        ),
        body: TabBarView(children: [
          //عليك
          ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: data1.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 5,
                  color: data1[i]['mony'] != 0
                      ? Color.fromARGB(255, 249, 123, 123)
                      : Colors.grey.shade300,
                  child: ListTile(
                    title: Text(
                      "${data1[i]['name']}",
                      style: TextStyle(fontSize: 28),
                    ),
                    subtitle: Text(" عليك${data1[i]['mony']}جنيه ",
                        style: TextStyle(fontSize: 20)),
                    leading: Icon(Icons.person),
                    onTap: () async {
                      SharedPreferences id =
                          await SharedPreferences.getInstance();
                      id.setInt("id", data1[i]['id']);
                      SharedPreferences namet =
                          await SharedPreferences.getInstance();

                      namet.setString("namet", data1[i]['name']);
                      Navigator.of(context).pushReplacementNamed("detailes");
                    },
                    trailing: IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 50,
                                  //icon: Icon(Icons.person),
                                  title: Text("هل انت متاكد من حذف العميل؟؟"),
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            int response1 = await sqdb.deleteData(
                                                "DELETE FROM rel WHERE id_user = ${data1[i]['id']}");
                                            int response2 = await sqdb.deleteData(
                                                "DELETE FROM users WHERE id = ${data1[i]['id']}");
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
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        )),
                  ),
                );
              }),
          ////////////////////////////////////ليك
          ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 5,
                  color: data[i]['mony'] != 0
                      ? Color.fromARGB(255, 139, 240, 154)
                      : Colors.grey.shade300,
                  child: ListTile(
                    onTap: () async {
                      SharedPreferences id =
                          await SharedPreferences.getInstance();
                      id.setInt("id", data[i]['id']);

                      SharedPreferences namet =
                          await SharedPreferences.getInstance();

                      namet.setString("namet", data[i]['name']);

                      Navigator.of(context).pushReplacementNamed("detailes");
                    },
                    title: Text("${data[i]['name']}",
                        style: TextStyle(fontSize: 28)),
                    subtitle: Text(" ليك ${data[i]['mony']}جنيه ",
                        style: TextStyle(fontSize: 20)),
                    leading: Icon(Icons.person),
                    trailing: IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 50,
                                  //icon: Icon(Icons.person),
                                  title: Text(" انت متاكد من حذف العميل؟؟"),
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            int response1 = await sqdb.deleteData(
                                                "DELETE FROM rel WHERE id_user = ${data[i]['id']}");
                                            int response2 = await sqdb.deleteData(
                                                "DELETE FROM users WHERE id = ${data[i]['id']}");
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
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        )),
                  ),
                );
              })
        ]),

        //////////////float//////////////////////////////////////////////////
        floatingActionButton: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              backgroundColor: Colors.grey,
              onPressed: () {
                nametrad = TextEditingController(text: "");
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 50,
                        //icon: Icon(Icons.person),
                        title: Text("اضافه عميل"),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nametrad,
                              maxLength: 20,
                              decoration: InputDecoration(
                                hintText: "اسم العميل",
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
                                  if (nametrad.text != '') {
                                    int response = await sqdb.insertData(
                                        "INSERT INTO users( `name`, `mony`, `who`) VALUES ('${nametrad.text}', 0, 'false')");
                                    print("$response");
                                    // Navigator.of(context)
                                    //     .pushReplacementNamed("home");
                                    Navigator.of(context).pop(context);
                                    setState(() {
                                      refresh = true;
                                    });
                                    refrsh();
                                  }
                                },
                                child: Text("اضافه"),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Icon(Icons.person_add),
            ),
          ],
        ),
      ),
    );
  }
}

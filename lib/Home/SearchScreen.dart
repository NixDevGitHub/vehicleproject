

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../loginPage.dart';
import '../sign_in.dart';
import 'UpdateScreen.dart';


class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}


class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String Searchname = "";
  //
//
  late FirebaseFirestore firebaseFirestore;
  CrudMethods crudMethods = new CrudMethods();
  late Stream blogsStream;
  Widget BlogsList() {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  Searchname = val;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: (Searchname != "" && Searchname != null)
                ? FirebaseFirestore.instance
                    .collection('Users')
                    .where("vehicleNumber", isGreaterThanOrEqualTo: Searchname)
                    .snapshots()
                : FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BlogsTile(
                          vehicleNumber:
                          (snapshot.data!.docs[index].data() as dynamic )['vehicleNumber'],
                          registrationNumber: (snapshot.data!.docs[index].data() as dynamic )!["registrationNumber"],
                          vehicleType:
                          (snapshot.data!.docs[index].data() as dynamic )["vehicleType"],
                          ownerName:
                          (snapshot.data!.docs[index].data() as dynamic )["ownerName"],
                          report: (snapshot.data!.docs[index].data() as dynamic )["report"],
                          price: (snapshot.data!.docs[index].data() as dynamic )["price"],
                          time: (snapshot.data!.docs[index].data() as dynamic )["timestamp"]
                              .toDate()
                              .toString(), contactInfo: '',
                        );
                      });
            }));
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Our ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Project",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
        drawer: Drawer(
          elevation: 20.0,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                ),
              ),
              ListTile(
                title: Text("Inbox"),
                leading: Icon(Icons.mail),
              ),
              ListTile(
                title: Text("Primary"),
                leading:  Icon(Icons.inbox),
              ),
              ListTile(
                title:  Text("Social"),
                leading:  Icon(Icons.people),
              ),
              ListTile(
                title:  Text("Logout"),
                leading:  Icon(Icons.logout),
                onTap: (){
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                },
              )
            ],
          ),
        ),
      body: BlogsList(),

    );
  }
}

class BlogsTile extends StatelessWidget {
  String vehicleNumber,
      registrationNumber,
      vehicleType,
      ownerName,
      contactInfo,
      report,
      price,
      time;
  BlogsTile(
      {
        required this.vehicleNumber,
      required this.registrationNumber,
      required this.vehicleType,
      required this.ownerName,
      required this.contactInfo,
      required this.report,
      required this.price,
      required this.time});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(7.0),
                child: Center(
                    child: Column(children: <Widget>[
                  Row(
                    //ROW 1
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 25, right: 25, top: 5, bottom: 5),
                        child: Icon(
                          Icons.electric_scooter_sharp,
                          color: Colors.black87,
                          size: 24.0,
                        ),
                      ),
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 25, top: 5, bottom: 5),
                            child: Text(vehicleNumber,
                                style: TextStyle(fontSize: 18))),
                      )
                    ],
                  ),
                  Divider(),
                  Row(//ROW 2
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.wysiwyg,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child: Text(registrationNumber,
                              style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                  Row(// ROW 3
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.merge_type_rounded,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child: Text(vehicleType,
                              style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                  Row(// ROW 3
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child:
                              Text(ownerName, style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                  Row(// ROW 3
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.assignment_outlined,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child: Text(report, style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                  Row(// ROW 3
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.money,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child: Text(price, style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                  Row(// ROW 3
                      children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 5),
                      child: Icon(
                        Icons.timer,
                        color: Colors.black87,
                        size: 24.0,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          child: Text(time, style: TextStyle(fontSize: 18))),
                    )
                  ]),
                  Divider(),
                ])),
              ),
            ],
          ),
        ),
      ), onTap: () {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new UpdateScreen(
                  vehicleNumber,
                  registrationNumber,
                  vehicleType,
                  ownerName,
                  contactInfo,
                  report,
                  price,
                  time)));
    },
    );
  }
}

class CrudMethods {
  getData() async {
    // ignore: deprecated_member_use
    return FirebaseFirestore.instance.collection("Users").snapshots();
  }
}

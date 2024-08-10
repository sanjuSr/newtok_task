import 'package:flutter/material.dart';
import 'package:newtok_task/ADMIN/AddLocationScreen.dart';
import 'package:newtok_task/Reg&Login/LoginPage.dart';



class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ADMIN DASHBOARD'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.redAccent[100],
                ),
                child: Text(
                  'Hello Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Add Location'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddLocationScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Text('HELLO ADMIN',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),),
        ),
      );
  }
}

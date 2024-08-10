import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newtok_task/USER/FOOTER.dart';
import 'package:newtok_task/USER/UploadExcelScreen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("USER HOME"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('countries').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
            
                var countries = snapshot.data!.docs;
            
                return ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    var country = countries[index];
                    return ExpansionTile(
                      title: Text(country['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: country.reference.collection('states').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
            
                            var states = snapshot.data!.docs;
            
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: states.length,
                              itemBuilder: (context, index) {
                                var state = states[index];
                                return Card(
                                  margin: EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("State: ${state['name']}", style: TextStyle(fontSize: 16)),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: state.reference.collection('districts').snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(child: CircularProgressIndicator());
                                            }
            
                                            var districts = snapshot.data!.docs;
            
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: districts.length,
                                              itemBuilder: (context, index) {
                                                var district = districts[index];
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 16),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("District: ${district['name']}",
                                                          style: TextStyle(fontSize: 16)),
                                                      StreamBuilder<QuerySnapshot>(
                                                        stream: district.reference.collection('cities').snapshots(),
                                                        builder: (context, snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return Center(child: CircularProgressIndicator());
                                                          }
            
                                                          var cities = snapshot.data!.docs;
            
                                                          return ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: cities.length,
                                                            itemBuilder: (context, index) {
                                                              var city = cities[index];
                                                              return Padding(
                                                                padding: const EdgeInsets.only(left: 16),
                                                                child: Text("City: ${city['name']}",
                                                                    style: TextStyle(fontSize: 16)),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          FooterWidget(),
        ],
      ),
    );
  }
}

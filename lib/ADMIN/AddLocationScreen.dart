import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {

  final TextEditingController CountryController = TextEditingController();
  final TextEditingController StateController = TextEditingController();
  final TextEditingController DistrictController = TextEditingController();
  final TextEditingController CityController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> _addLocationData() async {
    String country = CountryController.text.trim();
    String state = StateController.text.trim();
    String district = DistrictController.text.trim();
    String city = CityController.text.trim();

    if (country.isNotEmpty) {
      DocumentReference countryRef = await _firestore.collection('countries').add({'name': country});

      if (state.isNotEmpty) {
        DocumentReference stateRef = await countryRef.collection('states').add({'name': state});

        if (district.isNotEmpty) {
          DocumentReference districtRef = await stateRef.collection('districts').add({'name': district});

          if (city.isNotEmpty) {
            await districtRef.collection('cities').add({'name': city});
          }
        }
      }
    }


    CountryController.clear();
    StateController.clear();
    DistrictController.clear();
    CityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD LOCATION"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 100,),
              TextField(
                controller: CountryController,
                decoration: InputDecoration(
                    hintText: "Country",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: StateController,
                decoration: InputDecoration(
                  hintText: "State",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: DistrictController,
                decoration: InputDecoration(
                  hintText: "District",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: CityController,
                decoration: InputDecoration(
                  hintText: "City",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: _addLocationData,
                child: Text('Add Location',style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

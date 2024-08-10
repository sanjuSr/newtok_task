import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherReportScreen extends StatefulWidget {
  final String fileName;

  WeatherReportScreen({required this.fileName});

  @override
  _WeatherReportScreenState createState() => _WeatherReportScreenState();
}

class _WeatherReportScreenState extends State<WeatherReportScreen> {
  List<Map<String, String>> _weatherReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final storageRef = FirebaseStorage.instance.ref().child('uploads/${widget.fileName}');
    try {
      final downloadUrl = await storageRef.getDownloadURL();
      final response = await http.get(Uri.parse(downloadUrl));
      var bytes = response.bodyBytes;
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, String>> locations = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if (row.isNotEmpty) {
            String country = row.length > 0 && row[0] != null ? row[0]!.value.toString() : '';
            String state = row.length > 1 && row[1] != null ? row[1]!.value.toString() : '';
            String district = row.length > 2 && row[2] != null ? row[2]!.value.toString() : '';
            String city = row.length > 3 && row[3] != null ? row[3]!.value.toString() : '';

            if (country.isNotEmpty || state.isNotEmpty || district.isNotEmpty || city.isNotEmpty) {
              locations.add({
                'country': country,
                'state': state,
                'district': district,
                'city': city,
              });
            }
          }
        }
      }

      for (var location in locations) {
        String locationQuery = _buildLocationQuery(location);
        if (locationQuery.isNotEmpty) {
          final apiKey = '192a36f37ec41b9e9902e8c62755c32f';
          final weatherUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$locationQuery&appid=$apiKey';
          final weatherResponse = await http.get(Uri.parse(weatherUrl));

          if (weatherResponse.statusCode == 200) {
            var weatherJson = json.decode(weatherResponse.body);
            setState(() {
              _weatherReports.add({
                'location': locationQuery,
                'description': weatherJson['weather'][0]['description'],
                'temperature': '${weatherJson['main']['temp']}°K',
                'humidity': '${weatherJson['main']['humidity']}%',
              });
            });
          } else {
            setState(() {
              _weatherReports.add({
                'location': locationQuery,
                'description': 'Failed to load weather data',
              });
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        _weatherReports.add({
          'location': 'Error',
          'description': 'Error fetching weather data: $e',
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _buildLocationQuery(Map<String, String> location) {
    List<String> queries = [];
    if (location['city']!.isNotEmpty) {
      queries.add(location['city']!);
    }
    if (location['district']!.isNotEmpty) {
      queries.add(location['district']!);
    }
    if (location['state']!.isNotEmpty) {
      queries.add(location['state']!);
    }
    if (location['country']!.isNotEmpty) {
      queries.add(location['country']!);
    }
    return queries.join(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WEATHER INFORMATION')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLayout1(),
            SizedBox(height: 20),
            _buildLayout2(),
            SizedBox(height: 20),
            _buildLayout3(),
            SizedBox(height: 20),
            _buildLayout4(),
            SizedBox(height: 20),
            _buildLayout5(),
          ],
        ),
      ),
    );
  }

  Widget _buildLayout1() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.redAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ListView',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _weatherReports.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${_weatherReports[index]['location']}',style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${_weatherReports[index]['description']}'),
                    Text('Temp: ${_weatherReports[index]['temperature']}'),
                    Text('Humidity: ${_weatherReports[index]['humidity']}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLayout2() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.redAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GridView', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _weatherReports.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_weatherReports[index]['location']}', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Weather: ${_weatherReports[index]['description']}'),
                      Text('Temp: ${_weatherReports[index]['temperature']}'),
                      Text('Humidity: ${_weatherReports[index]['humidity']}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLayout3() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.redAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Card List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: _weatherReports.map((report) {
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text('${report['location']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weather: ${report['description']}'),
                      Text('Temperature: ${report['temperature']}'),
                      Text('Humidity: ${report['humidity']}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout4() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.redAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detailed List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _weatherReports.map((report) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${report['location']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Weather: ${report['description']}'),
                    Text('Temperature: ${report['temperature']}'),
                    Text('Humidity: ${report['humidity']}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout5() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.redAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horizontal Scroll', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _weatherReports.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 180,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text('${_weatherReports[index]['location']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Weather: ${_weatherReports[index]['description']}'),
                        Text('Temp: ${_weatherReports[index]['temperature']}'),
                        Text('Humidity: ${_weatherReports[index]['humidity']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

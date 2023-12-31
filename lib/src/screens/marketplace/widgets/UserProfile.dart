import 'package:flutter/material.dart';
import 'package:kima/src/screens/marketplace/ClassiFied_ProviderMarketPlace.dart';


class Classified1 {
  final int id;
  final String title;
  final String description;
  final String location;
  final String category;
  final String createdBy;
  final String profile;

  Classified1({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.createdBy,
    required this.profile,
  });

  factory Classified1.fromJson(Map<String, dynamic> json) {
    return Classified1(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      category: json['category'],
      createdBy: json['createdBy'],
      profile: json['profile'],
    );
  }
}

class ClassifiedProviderMarketPlace {
  Future<List<Classified1>> getClassifieds1() async {
    // Dummy data example for a list of classifieds
    List<Map<String, dynamic>> classifiedListData = [
      // ... (Your existing dummy data)
    ];

    // Convert dummy data to the list of Classified objects
    List<Classified1> classifiedList = classifiedListData
        .map((data) => Classified1.fromJson(data))
        .toList();

    return classifiedList;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classified App',
      home: ClassifiedListScreen(),
    );
  }
}

class ClassifiedListScreen extends StatelessWidget {
  final ClassifiedProviderMarketPlace classifiedProvider =
  ClassifiedProviderMarketPlace();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classified App'),
      ),
      body: FutureBuilder<List<Classified1>>(
        future: classifiedProvider.getClassifieds1(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No classifieds available'),
            );
          } else {
            return ClassifiedList(classifieds: snapshot.data!);
          }
        },
      ),
    );
  }
}

class ClassifiedList extends StatelessWidget {
  final List<Classified1> classifieds;

  ClassifiedList({required this.classifieds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: classifieds.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(classifieds[index].title),
          subtitle: Text(classifieds[index].description),
          onTap: () {
            _showPostDetails(context, classifieds[index]);
          },
        );
      },
    );
  }

  void _showPostDetails(BuildContext context, Classified1 classified) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Posted By: ${classified.createdBy}'),
              Text('Profile: ${classified.profile}'),
              Text('Description: ${classified.description}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
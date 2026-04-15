import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Categories(), debugShowCheckedModeBanner: false);
  }
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.lightGreen,
                  child: Icon(Icons.tv),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.lightGreen,
                  child: Icon(Icons.shopping_cart),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.lightGreen,
                  child: Icon(Icons.menu_book),
                ),
              ],
            ),
          ),
          Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addcat()),
                );
              },
              child: Text(
                'Add Category',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class Addcat extends StatefulWidget {
  const Addcat({super.key});

  @override
  State<Addcat> createState() => _AddcatState();
}

class _AddcatState extends State<Addcat> {
  final nameController = TextEditingController();
  final iconController = TextEditingController();
  final colourController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: iconController,
            decoration: InputDecoration(labelText: "Icon"),
          ),
          TextField(
            controller: colourController,
            decoration: InputDecoration(labelText: "Colour"),
          ),
          SizedBox(height: 100),

          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty == true ||
                  iconController.text.isEmpty == true ||
                  colourController.text.isEmpty == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Do not leave any field',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green[300],
                  ),
                );
              } else {
                // insertUser();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Category Successfully Added',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green[300],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('INSERT USER', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

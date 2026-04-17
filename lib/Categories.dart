import 'package:flutter/material.dart';
import 'package:project/Subscriptions.dart';
import 'Subscriptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(const MyApp());
// }

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
        backgroundColor: Color(0xFF7A9E6E),
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
                  color: Color(0xFF7A9E6E),
                  child: Icon(Icons.tv),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Color(0xFF7A9E6E),
                  child: Icon(Icons.shopping_cart),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Color(0xFF7A9E6E),
                  child: Icon(Icons.menu_book),
                ),
              ],
            ),
          ),
          Spacer(),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF7A9E6E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addcat()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD6E8CC),
                foregroundColor: Colors.black,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Add Category',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Subscriptions()),
                  );
                },

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on_outlined, color: Colors.black),
                    Text('Subscriptions', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view, color: Colors.black),
                  Text('Categories', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<String> colours = <String>[
  'red',
  'orange',
  'yellow',
  'green',
  'blue',
  'purple',
];

class Addcat extends StatefulWidget {
  const Addcat({super.key});

  @override
  State<Addcat> createState() => _AddcatState();
}

class _AddcatState extends State<Addcat> {
  final nameController = TextEditingController();
  final iconController = TextEditingController();
  final colourController = TextEditingController();
  String dropdownValue = colours.first;

  //add methods here
  CollectionReference categories = FirebaseFirestore.instance.collection('Categories');

  String id = '';
  String name = '';
  String icon = '';
  String colour = '';
  String subscriptions = '';

  Future<void> addCategories() async {
    if (name.isNotEmpty && icon.isNotEmpty && colour.isEmpty && subscriptions.isEmpty) {
      await categories.add({'id': id,'name': name, 'icon': icon, 'colour': colour, 'subscriptions': subscriptions });
      setState(() {
        id = '';
        name = '';
        icon = '';
        colour = '';
        subscriptions = '';
      });
    }
  }

  Future<void> updateCategories(String id) async {
    await categories
        .doc(id)
        .update({'id': 'new id', 'name': 'new name', 'icon': 'new icon', 'colour': 'new colour', 'subscriptions': 'new subscriptions'});
  }

  Future<void> deleteCategories(String id) async {
    await categories.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
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
          DropdownButton(
            value: dropdownValue,
            icon: Icon(Icons.brush_outlined),
            elevation: 16,

            items: colours.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
          // SizedBox(height: 100),
          Spacer(),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF7A9E6E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD6E8CC),
                foregroundColor: Colors.black,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Add Category',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Subscriptions()),
                  );
                },

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on_outlined, color: Colors.black),
                    Text('Subscriptions', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Categories()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.grid_view, color: Colors.black),
                    Text('Categories', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

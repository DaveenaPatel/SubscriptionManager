import 'package:flutter/material.dart';
import 'package:project/Subscriptions.dart';
import 'Subscriptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBvwIWP5gfD_IuZlOj44Z5N7xQefFMFN2U",
          appId: "283615807014",
          messagingSenderId: "1:283615807014:android:b7d291f99bab0ab72e08e7",
          projectId: "subwallet-864ed"));
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

  Color getColourFromString(String colour) {
    if (colour.startsWith('#')) {
      return Color(int.parse('FF${colour.substring(1)}', radix: 16));
    }
    switch (colour.toLowerCase()) {
      case 'red':    return Colors.red;
      case 'orange': return Colors.orange;
      case 'yellow': return Colors.yellow;
      case 'green':  return Colors.green;
      case 'blue':   return Colors.blue;
      case 'purple': return Colors.purple;
      default:       return Color(0xFF7A9E6E);
    }
  }

class _CategoriesState extends State<Categories> {
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');
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
            child: StreamBuilder<QuerySnapshot>(
                stream: categories.snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text('Something went wrong'),);
                  }

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  if(docs.isEmpty){
                    return Center(child: Text('No Categories'),);
                  }
                  
                  return GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CatWithSub(
                                categoryName: data['name'] ?? '',
                                categoryColor: getColourFromString(data['color'] ?? ''),
                              ),
                            ),
                          );
                        },
                        child:
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: getColourFromString(data['color'] ?? ''),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category, color: Colors.white, size: 30),
                              SizedBox(height: 8),
                              Text(
                                data['name'] ?? '',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );

                    },
                  );

                }
            )

          ),
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
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  String id = '';
  String name = '';
  String icon = '';
  String colour = '';
  String subscriptions = '';

  Future<void> addCategories() async {
    if (name.isNotEmpty && icon.isNotEmpty && colour.isNotEmpty) {
      await categories.add({'id': id,'name': name, 'icon': icon, 'color': colour, 'subscriptions': subscriptions });
      setState(() {
        id = '';
        name = '';
        icon = '';
        colour = '';
        subscriptions = '';
        subscriptions = '';
        nameController.clear();
        iconController.clear();
        dropdownValue = colours.first;
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
              onPressed: () async {
                if (nameController.text.isEmpty == true ||
                    iconController.text.isEmpty == true) {
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
                    name = nameController.text;
                    icon = iconController.text;
                    colour = dropdownValue;
                    await addCategories();
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


class CatWithSub extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  const CatWithSub({super.key, required this.categoryColor, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final subs = FirebaseFirestore.instance.collection('subscriptions').where('category', isEqualTo: categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),

      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: subs.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(child: Text('No Subscriptions in this Category'),);
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.attach_money, color: Colors.white, size: 22),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          data['name'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        '\$${data['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
      ),


      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on_outlined, color: Colors.black),
                Text('Subscriptions', style: TextStyle(fontSize: 12)),
              ],
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
      ),
    );
  }
}

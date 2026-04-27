import 'package:flutter/material.dart';
import 'dart:math';
import 'Categories.dart';
import 'settings.dart';
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
    return MaterialApp(home: Subscriptions(), debugShowCheckedModeBanner: false);
  }
}

// main subscription screen
class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  CollectionReference subscriptionsRef =
  FirebaseFirestore.instance.collection('subscriptions');

  // Delete subscription from Firestore
  Future<void> _deleteSubscription(String id) async {
    await subscriptionsRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Settings()),
        //     );
        //   },
        //   child: Icon(Icons.arrow_circle_right_outlined),
        // ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subscriptionsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF7A9E6E)));
          }

          final docs = snapshot.data!.docs;

          // Calculate total monthly from firestore data
          double totalMonthly = docs.fold(0, (sum, doc) {
            return sum + (double.tryParse(doc['price'].toString()) ?? 0);
          });

          return Column(
            children: [
              //pie chart
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CustomPaint(
                    size: Size(200, 200),
                    painter: PieChartPainter(docs),
                  ),
                ),
              ),

              // subscription list
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: docs.map((doc) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Icon bubble
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFB5738A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.attach_money, color: Colors.white, size: 22),
                          ),
                          SizedBox(width: 12),
                          // Name
                          Expanded(
                            child: Text(
                              doc['name'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // Edit button
                          IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSubscription(
                                    docId: doc.id,
                                    currentName: doc['name'],
                                    currentPrice: doc['price'].toString(),
                                    currentCategory: doc['category'].toString(),
                                    currentInterval: doc['interval'],
                                    subscriptionsRef: subscriptionsRef,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deleteSubscription(doc.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              //total monthly
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF7A9E6E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Monthly',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          totalMonthly.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddSubscription(
                            subscriptionsRef: subscriptionsRef,
                          )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
              ),

              //bottom nav bar
              Container(
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
            ],
          );
        },
      ),
    );
  }
}

// pie chart
class PieChartPainter extends CustomPainter {
  final List<QueryDocumentSnapshot> docs;

  PieChartPainter(this.docs);

  final List<Color> colors = [
    Color(0xFFE8A838),
    Color(0xFFE07040),
    Color(0xFFB5738A),
    Color(0xFF7A9E6E),
    Color(0xFF6888C0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total = docs.fold(0.0, (sum, doc) =>
    sum + (double.tryParse(doc['price'].toString()) ?? 0));
    if (total == 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    double startAngle = -pi / 2;

    for (int i = 0; i < docs.length; i++) {
      final price = double.tryParse(docs[i]['price'].toString()) ?? 0;
      final sweepAngle = (price / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─── Add Subscription Screen ───
class AddSubscription extends StatefulWidget {
  final CollectionReference subscriptionsRef;

  const AddSubscription({super.key, required this.subscriptionsRef});

  @override
  State<AddSubscription> createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final intervalController = TextEditingController();

  // Add to Firestore (like teacher's addUser)
  Future<void> _addSubscription() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty ||
        intervalController.text.isEmpty) {
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
      await widget.subscriptionsRef.add({
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0,
        'category': categoryController.text,
        'interval': intervalController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subscription Successfully Added',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[300],
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: intervalController,
              decoration: InputDecoration(
                labelText: 'Interval',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF7A9E6E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: _addSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD6E8CC),
                  foregroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Add Subscription', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// edit subscription screen
class EditSubscription extends StatefulWidget {
  final String docId;
  final String currentName;
  final String currentPrice;
  final String currentCategory;
  final String currentInterval;
  final CollectionReference subscriptionsRef;

  const EditSubscription({
    super.key,
    required this.docId,
    required this.currentName,
    required this.currentPrice,
    required this.currentCategory,
    required this.currentInterval,
    required this.subscriptionsRef,
  });

  @override
  State<EditSubscription> createState() => _EditSubscriptionState();
}

class _EditSubscriptionState extends State<EditSubscription> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController categoryController;
  late TextEditingController intervalController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    priceController = TextEditingController(text: widget.currentPrice);
    categoryController = TextEditingController(text: widget.currentCategory);
    intervalController = TextEditingController(text: widget.currentInterval);
  }

  // update
  Future<void> _updateSubscription() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
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
      try {
        await widget.subscriptionsRef.doc(widget.docId).update({
          'name': nameController.text,
          'price': double.tryParse(priceController.text) ?? 0,
          'category': categoryController.text,
          'interval': intervalController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Subscription Updated',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green[300],
          ),
        );
        Navigator.pop(context);
      } catch (error) {
        print('Failed to update');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Subscription', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: intervalController,
              decoration: InputDecoration(
                labelText: 'Interval',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF7A9E6E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: _updateSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD6E8CC),
                  foregroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('SAVE CHANGES', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
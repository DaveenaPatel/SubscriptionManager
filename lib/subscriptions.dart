import 'package:flutter/material.dart';
import 'dart:math';
import 'Categories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Subscriptions(), debugShowCheckedModeBanner: false);
  }
}

//hardcoded for now
class Subscription {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;

  Subscription({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });
}

List<Subscription> subscriptions = [
  Subscription(name: 'Netflix', amount: 3000, icon: Icons.tv, color: Color(0xFFB5738A)),
  Subscription(name: 'Spotify', amount: 2500, icon: Icons.tv, color: Color(0xFFB5738A)),
  Subscription(name: 'Gym', amount: 4500, icon: Icons.fitness_center, color: Color(0xFFE8A838)),
];

// main subscription screen
class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  void _deleteSubscription(int index) {
    setState(() {
      subscriptions.removeAt(index);
    });
  }

  double get totalMonthly =>
      subscriptions.fold(0, (sum, s) => sum + s.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
        leading: Icon(Icons.arrow_circle_right_outlined),
      ),
      body: Column(
        children: [
          // Chart Placeholder
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CustomPaint(
                size: Size(200, 200),
                painter: PieChartPainter(subscriptions),
              ),
            ),
          ),

          // subcrioption list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
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
                          color: sub.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(sub.icon, color: Colors.white, size: 22),
                      ),
                      SizedBox(width: 12),
                      // Name
                      Expanded(
                        child: Text(
                          sub.name,
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
                                subscription: sub,
                                index: index,
                                onSave: (updated) {
                                  setState(() {
                                    subscriptions[index] = updated;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () => _deleteSubscription(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Monthly total
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
                      '${totalMonthly.toStringAsFixed(2)}',
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
                      MaterialPageRoute(builder: (context) => AddSubscription()),
                    ).then((_) => setState(() {}));
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

          // Navigation
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
      ),
    );
  }
}

// Painter
class PieChartPainter extends CustomPainter {
  final List<Subscription> subscriptions;

  PieChartPainter(this.subscriptions);

  final List<Color> colors = [
    Color(0xFFE8A838),
    Color(0xFFE07040),
    Color(0xFFB5738A),
    Color(0xFF7A9E6E),
    Color(0xFF6888C0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total = subscriptions.fold(0.0, (sum, s) => sum + s.amount);
    if (total == 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    double startAngle = -pi / 2;

    for (int i = 0; i < subscriptions.length; i++) {
      final sweepAngle = (subscriptions[i].amount / total) * 2 * pi;
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

// add subcripption screen
class AddSubscription extends StatefulWidget {
  const AddSubscription({super.key});

  @override
  State<AddSubscription> createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final intervalController = TextEditingController();

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
            // ── Fields ──
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
            TextField(
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
                onPressed: () {
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
                    setState(() {
                      subscriptions.add(Subscription(
                        name: nameController.text,
                        amount: double.tryParse(priceController.text) ?? 0,
                        icon: Icons.attach_money,
                        color: Color(0xFF7A9E6E),
                      ));
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD6E8CC),
                  foregroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Add Subscription',
                  style: TextStyle(fontSize: 16),
                ),
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
  final Subscription subscription;
  final int index;
  final Function(Subscription) onSave;

  const EditSubscription({
    super.key,
    required this.subscription,
    required this.index,
    required this.onSave,
  });

  @override
  State<EditSubscription> createState() => _EditSubscriptionState();
}

class _EditSubscriptionState extends State<EditSubscription> {
  late TextEditingController nameController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.subscription.name);
    amountController = TextEditingController(text: widget.subscription.amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Subscription', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || amountController.text.isEmpty) {
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
                widget.onSave(Subscription(
                  name: nameController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  icon: widget.subscription.icon,
                  color: widget.subscription.color,
                ));
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
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('SAVE CHANGES', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
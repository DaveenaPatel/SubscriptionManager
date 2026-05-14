import 'package:flutter/material.dart';
import 'Categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Settings.dart';
import 'settingsValues.dart';

// main subscription screen
// interval options
const List<String> intervalOptions = [
  '1 Week',
  '2 Weeks',
  '1 Month',
  '6 Months',
  '1 Year',
];

// main Subscriptions screen
class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, String> _categoryColors = {};

  late final Query subscriptionsQuery = FirebaseFirestore.instance
      .collection('subscriptions')
      .where('userId', isEqualTo: currentUserId);

  late final CollectionReference subscriptionsRef =
  FirebaseFirestore.instance.collection('subscriptions');

  @override
  void initState() {
    super.initState();
    _fetchCategoryColors().then((colors) {
      setState(() => _categoryColors = colors);
    });
  }

  // Fetch category colors from Firestore
  Future<Map<String, String>> _fetchCategoryColors() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('categories').get();
    final Map<String, String> colorMap = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name']?.toString() ?? '';
      final color = data['color']?.toString() ?? '';
      if (name.isNotEmpty) colorMap[name] = color;
    }
    return colorMap;
  }

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
        leading: GestureDetector(
          onHorizontalDragEnd: (d) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
          child: Icon(Icons.arrow_circle_right_outlined),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subscriptionsQuery.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFF7A9E6E)));
          }

          final docs = snapshot.data!.docs;

          // Empty state
          if (docs.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.subscriptions_outlined,
                            size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'No subscriptions found.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        // Text(
                        //   'No subscriptions found.',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        SizedBox(height: 8),
                        Text(
                          'Add a new subscription to get started!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        // Text(
                        //   'Add a new subscription to get started!',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.grey[400],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(totalMonthly: 0, docs: docs),
              ],
            );
          }

          double totalMonthly = docs.fold(0, (sum, doc) {
            return sum + (double.tryParse(doc['price'].toString()) ?? 0);
          });

          return Column(
            children: [
              // pie chart
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: QuickChartPie(
                    docs: docs,
                    categoryColors: _categoryColors,
                  ),
                ),
              ),

              // subscription list
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: docs.map((doc) {
                    final category = doc['category']?.toString() ?? '';
                    final colorStr = _categoryColors[category] ?? '';
                    final bubbleColor = getColourFromString(colorStr);

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.attach_money,
                                color: Colors.white, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doc['name'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
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
                                    currentCategory: category,
                                    currentInterval: doc['interval'],
                                    subscriptionsRef: subscriptionsRef,
                                  ),
                                ),
                              );
                            },
                          ),
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

              _buildBottomBar(totalMonthly: totalMonthly, docs: docs),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(
      {required double totalMonthly,
        required List<QueryDocumentSnapshot> docs}) {
    return Column(
      children: [
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
                  // Text(
                  //   'Total Monthly',
                  //   style: TextStyle(color: Colors.white70, fontSize: 12),
                  // ),
                  ValueListenableBuilder<String>(
                    valueListenable: language,
                    builder: (context, lang, _) {
                      return Text(translate('totalMonthly'), style: TextStyle(color: Colors.white70, fontSize: 12),);
                    },
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: currency,
                    builder: (context, selectedCurrency, _) {
                      double converted = convertPrice(totalMonthly, selectedCurrency);
                      return Text(
                        '$selectedCurrency ${converted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSubscription(
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
                  ValueListenableBuilder<String>(
                    valueListenable: language,
                    builder: (context, lang, _) {
                      return Text(translate('subscriptions'), style: TextStyle(fontSize: 12));
                    },
                  ),
                  // Text('Subscriptions', style: TextStyle(fontSize: 12)),
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
                    ValueListenableBuilder<String>(
                      valueListenable: language,
                      builder: (context, lang, _) {
                        return Text(translate('categories'));
                      },
                    ),
                    // Text('Categories', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//QuickChart pie widget
class QuickChartPie extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;
  final Map<String, String> categoryColors;

  const QuickChartPie(
      {super.key, required this.docs, required this.categoryColors});

  String _toRgba(String colorStr) {
    switch (colorStr.toLowerCase()) {
      case 'red':    return 'rgba(244,67,54,0.9)';
      case 'orange': return 'rgba(255,152,0,0.9)';
      case 'yellow': return 'rgba(255,235,59,0.9)';
      case 'green':  return 'rgba(76,175,80,0.9)';
      case 'blue':   return 'rgba(33,150,243,0.9)';
      case 'purple': return 'rgba(156,39,176,0.9)';
      default:
        if (colorStr.startsWith('#') && colorStr.length == 7) {
          final r = int.parse(colorStr.substring(1, 3), radix: 16);
          final g = int.parse(colorStr.substring(3, 5), radix: 16);
          final b = int.parse(colorStr.substring(5, 7), radix: 16);
          return 'rgba($r,$g,$b,0.9)';
        }
        return 'rgba(122,158,110,0.9)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> categoryTotals = {};
    for (final doc in docs) {
      final category = doc['category']?.toString() ?? 'Other';
      final price = double.tryParse(doc['price'].toString()) ?? 0;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + price;
    }

    final labels = categoryTotals.keys.toList();
    final values = categoryTotals.values.toList();
    final colors = labels.map((l) => _toRgba(categoryColors[l] ?? '')).toList();

    final labelsJson = '[${labels.map((l) => '"$l"').join(',')}]';
    final valuesJson = '[${values.join(',')}]';
    final colorsJson = '[${colors.map((c) => '"$c"').join(',')}]';

    final chartConfig = Uri.encodeComponent(
      '{"type":"pie",'
          '"data":{"labels":$labelsJson,'
          '"datasets":[{"data":$valuesJson,"backgroundColor":$colorsJson}]},'
          '"options":{"plugins":{"legend":{"position":"bottom"}}}}',
    );

    final url = 'https://quickchart.io/chart?c=$chartConfig&w=300&h=300&backgroundColor=white';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: 300,
        height: 300,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 300,
            height: 300,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF7A9E6E)),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: 300,
            height: 300,
            child: Center(
              child: Text('Chart unavailable',
                  style: TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
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
  String _selectedInterval = intervalOptions.first;

  Future<void> _addSubscription() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty) {
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
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0,
        'category': categoryController.text,
        'interval': _selectedInterval,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          // Text(
          //   'Subscription Successfully Added',
          //   style: TextStyle(color: Colors.black),
          //   textAlign: TextAlign.center,
          // ),
          ValueListenableBuilder<String>(
            valueListenable: language,
            builder: (context, lang, _) {
              return Text(translate('ss'), style: TextStyle(color: Colors.black));
            },
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
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('addSubscription'), textAlign: TextAlign.center);
          },
        ),
        // Text('Add Subscription', textAlign: TextAlign.center),
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
                labelText: translate('name'),
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
                labelText: translate('price'),
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
              onTap: () async {
                final selected = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Categories(pickMode: true)),
                );
                if (selected != null) {
                  categoryController.text = selected;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: translate('category'),
                    labelStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.arrow_drop_down),
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
            SizedBox(height: 24),
            // Interval dropdown
            Text(
              'Billing Interval',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedInterval,
              decoration: InputDecoration(
                labelText: translate('interval'),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
              items: intervalOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedInterval = value);
                }
              },
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
                child:
                ValueListenableBuilder<String>(
                  valueListenable: language,
                  builder: (context, lang, _) {
                    return Text(translate('addSubscription'), style: TextStyle(fontSize: 16));
                  },
                ),
                // Text('Add Subscription', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Edit Subscription Screen ───
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
  late String _selectedInterval;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    priceController = TextEditingController(text: widget.currentPrice);
    categoryController = TextEditingController(text: widget.currentCategory);
    _selectedInterval = intervalOptions.contains(widget.currentInterval)
        ? widget.currentInterval
        : intervalOptions.first;
  }

  Future<void> _updateSubscription() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          ValueListenableBuilder<String>(
            valueListenable: language,
            builder: (context, lang, _) {
              return Text(translate('empty'), style: TextStyle(color: Colors.black), textAlign: TextAlign.center,);
            },
          ),
          // Text(
          //   'Do not leave any field',
          //   style: TextStyle(color: Colors.black),
          //   textAlign: TextAlign.center,
          // ),
          backgroundColor: Colors.green[300],
        ),
      );
    } else {
      try {
        await widget.subscriptionsRef.doc(widget.docId).update({
          'name': nameController.text,
          'price': double.tryParse(priceController.text) ?? 0,
          'category': categoryController.text,
          'interval': _selectedInterval,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            // Text(
            //   'Subscription Updated',
            //   style: TextStyle(color: Colors.black),
            //   textAlign: TextAlign.center,
            // ),
            ValueListenableBuilder<String>(
              valueListenable: language,
              builder: (context, lang, _) {
                return Text(translate('subscriptionUpdated'), style: TextStyle(color: Colors.black), textAlign: TextAlign.center,);
              },
            ),
            backgroundColor: Colors.green[300],
          ),
        );
        Navigator.pop(context);
      } catch (error) {
        print('Failed to update: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('editSubscriptions'),textAlign: TextAlign.center,);
          },
        ),
        // Text('Edit Subscription', textAlign: TextAlign.center),
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
                labelText: translate('name'),
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
                labelText: translate('price'),
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
              onTap: () async {
                final selected = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Categories(pickMode: true)),
                );
                if (selected != null) {
                  categoryController.text = selected;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: translate('category'),
                    suffixIcon: Icon(Icons.arrow_drop_down),
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
            SizedBox(height: 24),
            // Interval dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Billing Interval',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedInterval,
              decoration: InputDecoration(
                labelText: translate('interval'),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7A9E6E)),
                ),
              ),
              items: intervalOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedInterval = value);
                }
              },
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
                child:
                ValueListenableBuilder<String>(
                  valueListenable: language,
                  builder: (context, lang, _) {
                    return Text(translate('saveChanges'), style:TextStyle(fontSize: 16));
                  },
                ),
                // Text('SAVE CHANGES', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
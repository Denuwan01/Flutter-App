import 'package:flutter/material.dart';
import 'profile.dart'; // Import your existing profile page

void main() {
  runApp(const MyApp());
}

class Product {
  final String name;
  final double price;
  final String imagePath;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 0,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Order App',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> products = [
    Product(name: 'Burger', price: 500.00, imagePath: 'assets/burger.png'),
    Product(name: 'Fries', price: 300.00, imagePath: 'assets/fries.png'),
    Product(name: 'Coke', price: 200.00, imagePath: 'assets/coke.png'),
    Product(name: 'Pizza', price: 800.00, imagePath: 'assets/pizza.png'),
    Product(
        name: 'Ice Cream', price: 240.00, imagePath: 'assets/ice-cream.png'),
  ];

  void _submitOrder() {
    List<Product> ordered = products.where((p) => p.quantity > 0).toList();
    if (ordered.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BillPage(orderList: ordered)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one item")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Food Menu'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/banner.jpg!bw700'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...products.map((product) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                leading: Image.asset(
                  product.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text('Rs. ${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (product.quantity > 0) product.quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${product.quantity}'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          product.quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Thank you for visiting!',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: _submitOrder,
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text('Submit Order'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class BillPage extends StatelessWidget {
  final List<Product> orderList;
  const BillPage({super.key, required this.orderList});

  double _calculateTotal() =>
      orderList.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();
    double tax = total * 0.05;
    double grandTotal = total + tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Burger Queen Pvt Ltd',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const Text('123, Main Street, Colombo, Sri Lanka'),
            const Text('Tel: +94 11 123 4567\n'),
            Text('Bill No: #${DateTime.now().millisecondsSinceEpoch}'),
            Text('Invoice No: INV${DateTime.now().millisecondsSinceEpoch}\n'),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Colors.teal),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('No.', style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Description',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Qty', style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Text('Rate', style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Text('Amount', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                ...orderList.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Product item = entry.value;
                  return TableRow(children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('$index')),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(item.name)),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('${item.quantity}')),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Rs. ${item.price.toStringAsFixed(2)}')),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            'Rs. ${(item.price * item.quantity).toStringAsFixed(2)}')),
                  ]);
                }),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total: Rs. ${total.toStringAsFixed(2)}'),
                  Text('Tax (5%): Rs. ${tax.toStringAsFixed(2)}'),
                  Text(
                    'Grand Total: Rs. ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text('Signature: ____________'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.teal, Colors.tealAccent]),
            ),
            child: Text('Menu',
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MyApp()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('This is the Profile Page'),
      ),
    );
  }
}

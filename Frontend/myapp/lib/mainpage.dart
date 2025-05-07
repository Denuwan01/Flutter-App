import 'package:flutter/material.dart';

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
    Product(
        name: 'Burger', price: 5.0, imagePath: 'assets/images/picture_1.png'),
    Product(
        name: 'Fries', price: 3.0, imagePath: 'assets/images/picture_2.png'),
    Product(name: 'Coke', price: 2.0, imagePath: 'assets/images/picture_3.png'),
    Product(
        name: 'Pizza', price: 8.0, imagePath: 'assets/images/picture_4.png'),
    Product(
        name: 'Ice Cream',
        price: 4.0,
        imagePath: 'assets/images/picture_5.png'),
  ];

  void _submitOrder() {
    List<Product> ordered = products.where((p) => p.quantity > 0).toList();
    if (ordered.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillPage(orderList: ordered),
        ),
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
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
          const SizedBox(height: 10),
          Container(
            height: 150,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'PLACE A BANNER HERE',
                style: TextStyle(fontSize: 20, color: Colors.black54),
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
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (product.quantity > 0) product.quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${product.quantity}'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          product.quantity++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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

  double _calculateTotal() {
    return orderList.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(title: const Text('Order Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Your Order Receipt',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Colors.teal),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Product',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Text('Price', style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Quantity',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                ...orderList.map((item) {
                  return TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('\$${item.price.toStringAsFixed(2)}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('${item.quantity}'),
                    ),
                  ]);
                }).toList(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.grey[100],
              ),
              child: Text(
                'Receipt ID: #ORD${DateTime.now().millisecondsSinceEpoch}\n'
                'Thank you for your order!\n'
                'Please show this receipt to the cashier.',
                style: const TextStyle(fontSize: 15),
              ),
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
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.teal, Colors.tealAccent]),
            ),
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

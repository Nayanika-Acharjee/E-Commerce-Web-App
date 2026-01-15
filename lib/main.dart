import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('orders');
  runApp(const MyApp());
}

/* ---------------- APP ROOT ---------------- */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
      ),
      home: const HomePage(),
    );
  }
}

/* ---------------- HOME ---------------- */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final products = const [
    {'name': 'T-Shirt', 'price': 499, 'image': 'https://www.mydesignation.com/cdn/shop/files/swag-112835.jpg?v=1728643580'},
    {'name': 'Shoes', 'price': 1999, 'image': 'https://hitz.co.in/cdn/shop/files/2651-BLUE.jpg?v=1755618834'},
    {'name': 'Watch', 'price': 2999, 'image': 'https://thewatchshop.in/cdn/shop/files/9947-Blk-A_1000x.jpg?v=1738318661'},
    {'name': 'Headphones', 'price': 1499, 'image': 'https://www.boat-lifestyle.com/cdn/shop/files/Artboard2_52206726-98d5-45a4-b521-f034ec83e7b6.png?v=1752729573'},
    {'name': 'Pants', 'price': 999, 'image': 'https://truewerk.com/cdn/shop/files/t1_werkpants_mens_olive_flat_lay_4825e693-f588-4813-bff0-1d4c46ce82ce.jpg?v=1759203265&width=1200'},
    {'name': 'Jacket', 'price': 1799, 'image': 'https://www.beatnik.in/cdn/shop/files/WJC2023027_RoyalBlue_7.jpg?v=1756211966'},
    {'name': 'Dress', 'price': 2499, 'image': 'https://www.vastranand.in/cdn/shop/files/1_bc4cce67-0c92-4034-b34b-644c1cd9ea66.jpg?v=1743074442'},
    {'name': 'Heels', 'price': 1299, 'image': 'https://eridani.in/cdn/shop/files/Nova-heels-302-Black_1.jpg?v=1747044523&width=2048'},
    {'name': 'Sunglasses', 'price': 249, 'image': 'https://www.dervin.in/cdn/shop/files/DRVN523a_4ecdfce5-0de2-482a-8c9c-2c9cc5160780.jpg?v=1720952481'},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(p) => setState(() => cart.add(p));
  void clearCart() => setState(() => cart.clear());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipShop'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search products',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersPage()),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(cart: cart, onClearCart: clearCart),
                  ),
                ),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(cart.length.toString(),
                        style: const TextStyle(fontSize: 15)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.50,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: p, onAdd: addToCart),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      height: 160,   // 🔽 smaller image height 
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: Image.network(
          p['image'].toString(),
          fit: BoxFit.cover,
        ),
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        p['name'].toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '₹${p['price']}',
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),

    const SizedBox(height: 2),
  ],
             ),

            ),
          );
        },
      ),
    );
  }
}

/* ---------------- DETAILS ---------------- */

class ProductDetailsPage extends StatelessWidget {
  final Map product;
  final Function(Map) onAdd;
  const ProductDetailsPage({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Column(
        children: [
          Image.network(product['image'], height: 300, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(product['name'], style: const TextStyle(fontSize: 22)),
          Text('₹${product['price']}',
              style: const TextStyle(color: Colors.orange, fontSize: 18)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                onAdd(product);
                Navigator.pop(c);
              },
              child: const Text('Add to Cart'),
            ),
          )
        ],
      ),
    );
  }
}

/* ---------------- CART ---------------- */

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback onClearCart;
  const CartPage({super.key, required this.cart, required this.onClearCart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total => widget.cart.fold(0, (s, i) => s + i['price'] as int);

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: widget.cart.isEmpty
          ? const Center(child: Text('Cart empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (_, i) {
                      final item = widget.cart[i];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name']),
                                  Text('₹${item['price']}',
                                      style: const TextStyle(color: Colors.orange)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() => widget.cart.removeAt(i)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    onPressed: () => Navigator.push(
                      c,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          cart: widget.cart,
                          onSuccess: widget.onClearCart,
                        ),
                      ),
                    ),
                    child: Text('Checkout ₹$total'),
                  ),
                )
              ],
            ),
    );
  }
}

/* ---------------- CHECKOUT ---------------- */

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback onSuccess;
  const CheckoutPage({super.key, required this.cart, required this.onSuccess});

  int get total => cart.fold(0, (s, i) => s + i['price'] as int);

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ...cart.map((i) => Text('${i['name']} - ₹${i['price']}')),
          const Divider(),
          Text('Total ₹$total', style: const TextStyle(fontSize: 22)),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            onPressed: () async {
              final box = Hive.box('orders');
              await box.add({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'amount': total,
                'date': DateTime.now().toString(),
              });
              onSuccess();
              Navigator.pushAndRemoveUntil(
                c,
                MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
                (r) => r.isFirst,
              );
            },
            child: const Text('Pay'),
          )
        ]),
      ),
    );
  }
}

/* ---------------- SUCCESS ---------------- */

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.check_circle, size: 90, color: Colors.green),
            SizedBox(height: 20),
            Text('Payment Successful', style: TextStyle(fontSize: 24))
          ]),
        ),
      );
}

/* ---------------- ORDERS ---------------- */

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext c) {
    final box = Hive.box('orders');
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: box.isEmpty
          ? const Center(child: Text('No Orders Yet'))
          : ListView.builder(
              itemCount: box.length,
              itemBuilder: (_, i) {
                final o = box.getAt(i);
                return ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text('Order #${o['id']}'),
                  subtitle: Text(o['date']),
                  trailing: Text('₹${o['amount']}'),
                );
              },
            ),
    );
  }
}

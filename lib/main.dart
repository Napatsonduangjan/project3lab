import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int total = 0;
  final List<Item> items = [ 
    Item(title: "iPad", price: 19000),
    Item(title: "iPad mini", price: 23000),
    Item(title: "iPad Air", price: 29000),
    Item(title: "iPad Pro", price: 32000),
  ];

  void incrementNumber(Item item, int delta) {
    setState(() {
      total += delta;
    });
  }

  void resetAll() {
    setState(() {
      total = 0;
      for (var item in items) {
        item.resetCount();
      }
    });
  }

  String formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Cart"),
          backgroundColor: Color.fromARGB(255, 157, 146, 224),
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ShoppingItem(
                      item: item,
                      onIncrement: (item, delta) {
                        incrementNumber(item, delta);
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Color.fromARGB(255, 206, 193, 231),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "${formatCurrency(total)} ฿",
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: resetAll,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 163, 137, 220),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const Text("Clear"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String title;
  final int price;
  int count = 0;

  Item({required this.title, required this.price});

  void resetCount() {
    count = 0;
  }
}

class ShoppingItem extends StatefulWidget {
  final Item item;
  final Function(Item item, int delta) onIncrement;

  ShoppingItem({
    required this.item,
    required this.onIncrement,
  });

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                style: const TextStyle(fontSize: 28),
              ),
              Text("${widget.item.price.toString()} ฿"),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (widget.item.count > 0) {
                    setState(() {
                      widget.item.count--;
                    });
                    widget.onIncrement(widget.item, -widget.item.price);
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              Text(
                widget.item.count.toString(),
                style: const TextStyle(fontSize: 28),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.item.count++;
                  });
                  widget.onIncrement(widget.item, widget.item.price);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

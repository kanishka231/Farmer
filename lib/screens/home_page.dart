import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  String searchQuery = "";
  String selectedCategory = "All";
  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/product.json');
      final data = await json.decode(response);
      setState(() {
        products = (data['products'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        categories = ["All"] +
            products.map((product) => product.category).toSet().toList();
      });
    } catch (e) {
      // You might want to show an error message to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
          (selectedCategory == "All" || product.category == selectedCategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Product Recommendations'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth > 600 ? 600 : double.infinity,
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 60, // Fixed height for the dropdown
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedCategory,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            menuMaxHeight:
                                300, // Set a maximum height for the dropdown menu
                            isDense: true, // Makes the dropdown more compact
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                    product: filteredProducts[index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

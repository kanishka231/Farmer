import 'package:flutter/material.dart';
import '../models/product.dart';

class QuantityDetailsPage extends StatefulWidget {
  final Product product;
  final String name;
  final String contactNumber;
  final String address;

  const QuantityDetailsPage({
    super.key,
    required this.product,
    required this.name,
    required this.contactNumber,
    required this.address,
  });

  @override
  _QuantityDetailsPageState createState() => _QuantityDetailsPageState();
}

class _QuantityDetailsPageState extends State<QuantityDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  int? quantity;
  String? packSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product: ${widget.product.name}',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth > 600 ? 400 : double.infinity,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the quantity';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              onSaved: (value) => quantity = int.parse(value!),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Pack Size'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the pack size';
                                }
                                return null;
                              },
                              onSaved: (value) => packSize = value,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      child: const Text('Submit Order'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _showOrderConfirmation();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Confirmation'),
          content: SingleChildScrollView(
            child: Text(
              'Thank you for your order!\n\n'
                  'Product: ${widget.product.name}\n'
                  'Quantity: $quantity\n'
                  'Pack Size: $packSize\n'
                  'Name: ${widget.name}\n'
                  'Contact: ${widget.contactNumber}\n'
                  'Address: ${widget.address}',
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
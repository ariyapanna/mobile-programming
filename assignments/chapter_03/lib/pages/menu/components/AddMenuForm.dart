import 'package:flutter/material.dart';
import 'package:chapter_03/models/menu.dart';

class AddMenuForm extends StatefulWidget {
  const AddMenuForm({super.key});

  @override
  State<AddMenuForm> createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name;
  late String _imageUrl;
  late double _price;
  MenuCategory _category = MenuCategory.Food; 

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Title
                const Center(
                  child: Text(
                    "Add Menu",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name Input
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter name" : null,
                  onSaved: (value) => _name = value!,   
                ),
                const SizedBox(height: 16),

                // Image URL Input
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter image URL" : null,
                  onSaved: (value) => _imageUrl = value!,
                ),
                const SizedBox(height: 16),

                // Price Input
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter price";
                    if (double.tryParse(value) == null) return "Invalid price";
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<MenuCategory>(
                    decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                    ),
                    value: _category,
                    items: MenuCategory.values
                        .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat.toString().split('.').last),
                            ))
                        .toList(),
                    onChanged: (value) {
                        setState(() {
                        _category = value!; 
                        });
                    },
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save"),
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Navigator.pop(context, Menu(name: _name, category: _category, imageUrl: _imageUrl, price: _price));
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:api_course/api_services/api_services.dart';
import 'package:api_course/models/put/update_product.dart';
import 'package:flutter/material.dart';

class UpdateProductScreen extends StatefulWidget {
  final PutProduct initialProduct;

  const UpdateProductScreen({super.key, required this.initialProduct});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiServices();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize form with existing product data
    _titleController.text = widget.initialProduct.title;
    _priceController.text = widget.initialProduct.price.toString();
    _descriptionController.text = widget.initialProduct.description;
    _categoryController.text = widget.initialProduct.category;
    _imageController.text = widget.initialProduct.image;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedProduct = PutProduct(
        id: widget.initialProduct.id,
        title: _titleController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        category: _categoryController.text,
        image: _imageController.text,
      );

      final result = await _apiService.updateProduct(updatedProduct);
      _showSuccessDialog(result);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(PutProduct product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Successful'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Product updated successfully:'),
                  const SizedBox(height: 16),
                  if (product.image.isNotEmpty)
                    Center(
                      child: Image.network(
                        product.image,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _buildProductDetailRow('ID:', product.id.toString()),
                  _buildProductDetailRow('Title:', product.title),
                  _buildProductDetailRow(
                    'Price:',
                    '\$${product.price.toStringAsFixed(2)}',
                  ),
                  _buildProductDetailRow('Category:', product.category),
                  const SizedBox(height: 8),
                  const Text('Description:'),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(product); // Return updated product
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Widget _buildProductDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: ProductValidators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: ProductValidators.validatePrice,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: ProductValidators.validateDescription,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: ProductValidators.validateCategory,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: ProductValidators.validateImageUrl,
              ),
              const SizedBox(height: 24),
              if (_imageController.text.isNotEmpty)
                Image.network(
                  _imageController.text,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Update Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductValidators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Image URL is required';
    }
    if (!Uri.tryParse(value)!.hasAbsolutePath) {
      return 'Enter a valid URL';
    }
    return null;
  }
}

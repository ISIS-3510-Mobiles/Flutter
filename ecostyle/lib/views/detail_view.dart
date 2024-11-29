import 'package:ecostyle/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/view_model/details_view_model.dart';
import 'package:ecostyle/shop/screens/checkout/checkout.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final FirebaseService _firebaseService = FirebaseService();
  String? selectedBrand;
  String? selectedMaterial;
  double? itemWeight;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final ProductModel item = ProductModel.fromMap(args['item']); // Producto seleccionado
    List<Map<String, dynamic>> data = args['allItems'];
    List<ProductModel> allItems = [];
    for (Map<String, dynamic> item in data) {
      ProductModel itemChanged = ProductModel.fromMap(item);
      allItems.add(itemChanged);
    }

    return ChangeNotifierProvider(
      create: (_) => DetailViewModel()..init(item, allItems), // Inicializamos el ViewModel
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF012826),
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search in EcoStyle',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                 Navigator.pushNamed(context, '/cart');
              },
            ),
            ],
          ),
        ),
        body: Consumer<DetailViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Se hace un reemplazo de Image.asset por Image.network
                    Image.network(
                      viewModel.currentItem.image, // La URL de la imagen desde Firebase Storage
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Icon(Icons.error, size: 50, color: Colors.red);
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      viewModel.currentItem.title, // Título del producto
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$ ${viewModel.currentItem.price}', // Precio del producto
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      viewModel.currentItem.description, // Descripción del producto
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      color: Colors.black54,
                      onPressed: () {
                        // Lógica para agregar a favoritos
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007451),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      ),
                      onPressed: () {
                        // Lógica para comprar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Buy now',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7FB9A8),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                      ),
                      onPressed: () {
                        final viewModel = Provider.of<DetailViewModel>(context, listen: false);
                        viewModel.addToCart(viewModel.currentItem);
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Add Impact:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      hint: Text('Select Brand'),
                      value: selectedBrand,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBrand = newValue;
                        });
                      },
                      items: <String>['Fast Fashion', 'Local', 'Handmade', 'Donated']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      hint: Text('Select Material'),
                      value: selectedMaterial,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMaterial = newValue;
                        });
                      },
                      items: <String>['Cotton', 'Polyester', 'Wool', 'Leather'] // Example materials
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        itemWeight = double.tryParse(value); // Convert the string to a double
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007451),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      ),
                      onPressed: () async {
                        if (selectedBrand != null && selectedMaterial != null && itemWeight != null) {
                          await _firebaseService.addImpact({
                            'item': viewModel.currentItem.title,
                            'brand': selectedBrand,
                            'material': selectedMaterial,
                            'weight': itemWeight,
                          });
                          // Optionally, show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Impact added successfully!')),
                          );
                        } else {
                          // Optionally, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all fields!')),
                          );
                        }
                      },
                      child: Text(
                        'Add Impact',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Similar products:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(viewModel.recommendedItems.length, (index) {
                          final recommendedItem = viewModel.recommendedItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  recommendedItem.image, // La URL de la imagen desde Firebase Storage
                                  height: 80,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Icon(Icons.error, size: 50, color: Colors.red);
                                  },
                                ),
                                SizedBox(height: 5),
                                Text(recommendedItem.title),
                                SizedBox(height: 5),
                                Text('\$ ${recommendedItem.price}'),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

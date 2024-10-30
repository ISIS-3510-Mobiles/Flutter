import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/view_model/details_view_model.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

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
                onPressed: () {},
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
                    Image.asset(
                      viewModel.currentItem.image, // Usamos la imagen del producto seleccionado
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
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
                        // Lógica para agregar al carrito
                        final viewModel = Provider.of<DetailViewModel>(context, listen: false);
                        viewModel.addToCart(viewModel.currentItem);
                      },
                      child: Text(
                        'Add to Cart',
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
                                Image.asset(
                                  recommendedItem.image,
                                  height: 80,
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

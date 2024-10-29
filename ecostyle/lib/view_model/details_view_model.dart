import 'package:flutter/material.dart';
import 'package:ecostyle/models/product_model.dart';

class DetailViewModel extends ChangeNotifier {
  late ProductModel currentItem;
  late List<ProductModel> recommendedItems;

  // Inicializar los datos del producto y las recomendaciones
  void init(ProductModel item, List<ProductModel> allItems) {
    currentItem = item;
    recommendedItems = _getRecommendedItems(item, allItems);
    notifyListeners(); // Notifica a la vista que los datos han cambiado
  }

  // Método para obtener los productos recomendados
  List<ProductModel> _getRecommendedItems(ProductModel currentItem, List<ProductModel> allItems) {
    String title = currentItem.title.toLowerCase();
    List<ProductModel> similarItems = [];

    // Buscar productos con palabras similares
    List<String> words = title.split(' ');
    int index = 0;
    bool found = false;

    while (index < words.length && !found) {
      String word = words.elementAt(index);
      for (var item in allItems) {
        if (item.title != currentItem.title && item.title.toLowerCase().contains(word)) {
          bool selected = false;
          for (ProductModel selectedItem in similarItems) {
            if (selectedItem.title == item.title) {
              selected = true;
            }
          }
          if (!selected) {
            similarItems.add(item);
          }
        }
      }
      if (similarItems.length >= 2) {
        found = true;
      }
      index++;
    }

    if (similarItems.isNotEmpty) {
      // Ordenar por precio
      if (similarItems.length < 3) {
        List<ProductModel> listItems = List.from(allItems);
        listItems.sort((a, b) => a.price.compareTo(b.price)); // Ordenar por precio
        bool selected = false;
        int index = 0;
        while (!selected) {
          ProductModel item = listItems.elementAt(index);
          bool alreadySelected = false;
          for (ProductModel selectedItem in similarItems) {
            if (selectedItem.title.toLowerCase() == item.title.toLowerCase() || item.title == currentItem.title) {
              alreadySelected = true;
            }
          }
          if (alreadySelected) {
            index++;
          } else {
            selected = true;
            similarItems.add(item);
          }
        }
      }
      similarItems.sort((a, b) => a.price.compareTo(b.price));
      return similarItems.take(3).toList(); // Retornamos los 3 más baratos
    } else {
      // Si no hay productos similares, buscar los más cercanos (ya implementados antes)
      List<ProductModel> listItems = List.from(allItems);
      listItems.sort((a, b) => a.price.compareTo(b.price)); // Ordenar por precio
      return listItems.take(3).toList(); // Retornamos los 3 más cercanos por precio
    }
  }

}
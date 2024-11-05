
import 'package:hive_ce_flutter/adapters.dart';
import 'package:ecostyle/models/product_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel(
      id: reader.readString(),
      title: reader.readString(),
      price: reader.readInt(),
      image: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      description: reader.readString(),
      category: reader.readString(),
      environmentalImpact: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.price);
    writer.writeString(obj.image);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
    writer.writeString(obj.description);
    writer.writeString(obj.category);
    writer.writeBool(obj.environmentalImpact);
  }
}

import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String title;
  final num price;
  final int quantity;
  final String? image;

  const OrderItemEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    this.image,
  });

  String get name => title;
  String? get imageUrl => image;

  @override
  List<Object?> get props => [id, title, price, quantity, image];
}

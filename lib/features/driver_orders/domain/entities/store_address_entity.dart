import 'package:equatable/equatable.dart';

class StoreAddressEntity extends Equatable {
  final String name;
  final String address;
  final String? phone;
  final String? avatar;
  final String? whatsAppNumber;

  const StoreAddressEntity({
    required this.name,
    required this.address,
    this.phone,
    this.avatar,
    this.whatsAppNumber,
  });

  String get addressLine => address;
  String? get phoneNumber => phone;

  @override
  List<Object?> get props => [name, address, phone, avatar, whatsAppNumber];
}

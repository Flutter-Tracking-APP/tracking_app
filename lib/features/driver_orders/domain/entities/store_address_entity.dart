import 'package:equatable/equatable.dart';

class StoreAddressEntity extends Equatable {
  final String name;
  final String address;
  final String? phone;
  final String? avatar;
  final String? whatsAppNumber;
  final double lat;
  final double lng;

  const StoreAddressEntity({
    required this.name,
    required this.address,
    this.phone,
    this.avatar,
    this.whatsAppNumber,
    this.lat = 30.0444,
    this.lng = 31.2357,
  });

  String get addressLine => address;
  String? get phoneNumber => phone;

  @override
  List<Object?> get props => [
        name,
        address,
        phone,
        avatar,
        whatsAppNumber,
        lat,
        lng,
      ];
}

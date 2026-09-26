import 'package:equatable/equatable.dart';

class UserAddressEntity extends Equatable {
  final String name;
  final String address;
  final String? phone;
  final String? avatar;

  const UserAddressEntity({
    required this.name,
    required this.address,
    this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, address, phone, avatar];
}

import 'package:travely/models/databaseModel.dart';

class UserModel extends DatabaseModel {
  String? phoneNumber;
  String? tripKey; // foreign key

  UserModel({
    this.phoneNumber,
    this.tripKey,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "phoneNumber": phoneNumber,
      "tripKey": tripKey,
    };
  }
}

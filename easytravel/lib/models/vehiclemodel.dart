import 'dart:io';

class Vehicle {
  int id;
  String brand;
  String model;
  String licenseNumber;
  String category;
  String service;
  String description;
  String price;
  File vehicleImage;
  File bluebookImage;
  int vendorId;

  Vehicle({
    this.id,
    this.brand,
    this.model,
    this.licenseNumber,
    this.category,
    this.service,
    this.description,
    this.price,
    this.vehicleImage,
    this.bluebookImage,
    this.vendorId,
  });

  // factory Vehicle.fromJson(Map<String, dynamic> json) {
  //   return Vehicle(
  //       id: json['id'],
  //       brand: json['brand'] as String,
  //       model: json['model'] as String,
  //       licenseNumber: json['licenseNumber'] as String,
  //       category: json['category'] as String,
  //       service: json['service'] as String,
  //       description: json['description'] as String,
  //       price: json['price'],
  //       vehicleImage: json['vehicleImage'],
  //       bluebookImage: json['bluebookImage'],
  //       vendorId: json['vendor_id']);
  // }
}

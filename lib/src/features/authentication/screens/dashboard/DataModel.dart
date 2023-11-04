// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
    String imageUrl;

    DataModel({
        required this.imageUrl,
    });

    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
    };
}

import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_app/model/base_response.dart';

part 'sale_model.g.dart';

@JsonSerializable()
class SaleModel extends BaseResponse {
  List<SaleModelReal> data;

  SaleModel(this.data) : super(0, '', true);

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleModelToJson(this);
}

@JsonSerializable()
class SaleModelReal {
  String title;
  bool open;
  List<Map<String,dynamic>> items;

  SaleModelReal(this.title, this.open, this.items);

  factory SaleModelReal.fromJson(Map<String, dynamic> json) =>
      _$SaleModelRealFromJson(json);

  Map<String, dynamic> toJson() => _$SaleModelRealToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) {
  return SaleModel(
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : SaleModelReal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..code = json['code'] as int
    ..msg = json['msg'] as String
    ..success = json['success'] as bool;
}

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };

SaleModelReal _$SaleModelRealFromJson(Map<String, dynamic> json) {
  return SaleModelReal(
    json['title'] as String,
    json['open'] as bool,
    (json['items'] as List)?.map((e) => e as Map<String, dynamic>)?.toList(),
  );
}

Map<String, dynamic> _$SaleModelRealToJson(SaleModelReal instance) =>
    <String, dynamic>{
      'title': instance.title,
      'open': instance.open,
      'items': instance.items,
    };

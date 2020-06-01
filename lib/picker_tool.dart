import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';


const double _kPickerHeight = 216.0;
const double _kItemHeight = 40.0;
const Color _kBtnColor = Color(0xFF323232); //50
const Color _kTitleColor = Color(0xFF787878); //120
const double _kTextFontSize = 17.0;

typedef _StringClickCallBack = void Function(int selectIndex, Object selectStr);
typedef _ArrayClickCallBack = void Function(List<int> selecteds, List<dynamic> strData);
typedef _DateClickCallBack = void Function(dynamic selectDateStr, dynamic selectDate);

enum DateType {
  YMD, // y, m, d
  YM, // y ,m
  YMD_HM, // y, m, d, hh, mm
  YMD_HMS, // y, m, d, hh, mm,ss
}

class PickerTool {
  /** 单列*/
  static void showStringPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    int normalIndex,
    PickerDataAdapter adapter,
    @required _StringClickCallBack clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: false),
        clickCallBack: (Picker picker, List<int> selecteds) {
      //          print(picker.adapter.text);
      clickCallBack(selecteds[0], data[selecteds[0]]);
    }, selecteds: [normalIndex ?? 0], title: title);
  }

  /** 多列 */
  static void showArrayPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    List<int> normalIndex,
    PickerDataAdapter adapter,
    @required _ArrayClickCallBack clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: true),
        clickCallBack: (Picker picker, List<int> selecteds) {
      clickCallBack(selecteds, picker.getSelectedValues());
    }, selecteds: normalIndex, title: title);
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter adapter,
    String title,
    List<int> selecteds,
    @required PickerConfirmCallback clickCallBack,
  }) {
    new Picker(
            adapter: adapter,
            title: new Text(title ?? "请选择",
                style:
                    TextStyle(color: _kTitleColor, fontSize: _kTextFontSize)),
            selecteds: selecteds,
            cancelText: '取消',
            confirmText: '确定',
            cancelTextStyle:
                TextStyle(color: _kBtnColor, fontSize: _kTextFontSize),
            confirmTextStyle:
                TextStyle(color: _kBtnColor, fontSize: _kTextFontSize),
            textAlign: TextAlign.right,
            itemExtent: _kItemHeight,
            height: _kPickerHeight,
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: clickCallBack)
        .showModal(context);
  }

  /** 日期选择器*/
  static void showDatePicker(
    BuildContext context, {
    DateType dateType,
    String title,
    DateTime maxValue,
    DateTime minValue,
    DateTime value,
    DateTimePickerAdapter adapter,
    @required _DateClickCallBack clickCallback,
  }) {
    int timeType;
    if (dateType == DateType.YM) {
      timeType = PickerDateTimeType.kYM;
    } else if (dateType == DateType.YMD_HM) {
      timeType = PickerDateTimeType.kYMDHM;
    } else if (dateType == DateType.YMD_HMS) {
      timeType = PickerDateTimeType.kMDYHMS;
    } else {
      timeType = PickerDateTimeType.kYMD;
    }

    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
              type: timeType,
              isNumberMonth: true,
              maxValue: maxValue,
              minValue: minValue,
              value: value ?? DateTime.now(),
            ),
        title: title, clickCallBack: (Picker picker, List<int> selecteds) {
      var time = (picker.adapter as DateTimePickerAdapter).value;
      var timeStr;
      if (dateType == DateType.YM) {
        timeStr = time.year.toString() + time.month.toString();
      } else if (dateType == DateType.YMD_HM) {
        timeStr = time.year.toString() +
            time.month.toString() +
            time.day.toString() +
            time.hour.toString() +
            time.minute.toString();
      } else if (dateType == DateType.YMD_HMS) {
        timeStr = time.year.toString() +
            time.month.toString() +
            time.day.toString() +
            time.hour.toString() +
            time.minute.toString() +
            time.second.toString();
      } else {
        timeStr = time.year.toString() + time.month.toString() + time.day.toString();
      }
      clickCallback(timeStr, picker.adapter.text);
    });
  }
}

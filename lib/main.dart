import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter_app/model/sale_model.dart';
import 'net/DioUtil.dart';
import 'package:common_utils/common_utils.dart';
import 'package:intl/intl.dart';
import './picker_tool.dart';

final logger = Logger();

//void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    startDateString = dateFormat.format(DateTime.now());
    startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    startTimeString = timeFormat.format(startTime);
    endTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59, 0, 0);
    endTimeString = timeFormat.format(endTime);
    _initData(1);
  }

  var dataType;
  var startDateString = '';
  var startTimeString = '';
  var endTimeString = '';
  DateTime dateTime;
  var startTime;
  var endTime;
  DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("HH:mm:ss");
  List<SaleModelReal> list = new List();

  _initData(int type) {
    dataType = type;
    var params = {
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": endTime.millisecondsSinceEpoch,
      "dataType": dataType
    };
    DioUtil().get("tools/dataTools/getDataList", pathParams: params,
        errorCallback: (msg) {
      logger.d('msg : $msg');
    }).then((data) {
      SaleModel saleModel = SaleModel.fromJson(data);
      List<SaleModelReal> dataList = saleModel.data;
      SaleModelReal saleModelReal = dataList[0];
      setState(() {
        if (dataType == 1) {
          _initData(2);
        } else if (dataType == 2) {
          _initData(3);
        } else if (dataType == 3) {
          _initData(4);
        } else if (dataType == 4) {
          _initData(5);
        }
        list.add(saleModelReal);
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('小娇数坊'),
        ),
        body: Container(
          child: ListView(
            children: _buildItems(context, list),
          ),
        ));
  }


  List<Widget> _buildItems(BuildContext context, List<SaleModelReal> saleModelRealList) {
    List<Widget> widgets = new List<Widget>();
    widgets.add(_buildDate(context, "日期", startDateString));
    widgets.add(_buildTime(context, "开始时间", startTimeString));
    widgets.add(_buildTime(context, "结束时间", endTimeString));
    for (var saleModelReal in saleModelRealList) {
      String title = saleModelReal.title;
      List<Map<String, dynamic>> items = saleModelReal.items;
      widgets.add(Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_buildTitle(title), _listView(context, items)],
        ),
      ));
    }
    return widgets;
  }

  Widget _listView(BuildContext context, List<Map<String, dynamic>> items) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
        physics: NeverScrollableScrollPhysics(), //禁用滑动事件
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _item(items[index]);
        },
      ),
    );
  }

  //点击选择日期
  _onSelectDate(BuildContext context) {
    PickerTool.showDatePicker(context,
        dateType: DateType.YMD,
        title: "选择日期",
        minValue: DateTime(2005, 5, 28),
        maxValue: DateTime(3005, 5, 28),
        value: dateTime, clickCallback: (var str, var time) {
          logger.d(time);
          setState(() {
            DateTime _pickDateTime = DateTime.parse(time);
            dateTime = _pickDateTime;
            startDateString = dateFormat.format(_pickDateTime);
            startTime = DateTime(_pickDateTime.year, _pickDateTime.month,
                _pickDateTime.day, 0, 0, 0, 0, 0);
            startTimeString = timeFormat.format(startTime);
            endTime = DateTime(_pickDateTime.year, _pickDateTime.month,
                _pickDateTime.day, 23, 59, 59, 0, 0);
            endTimeString = timeFormat.format(endTime);
            list.clear();
            _initData(1);
          });
        });
  }

  Widget _buildDate(BuildContext context, String title, String date) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        height: 24,
        child: InkWell(
            child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _buildSubItem(title),
            _buildSubItem2(date),
            Container(
                height: 24,
                width: 100,
                child: new MaterialButton(
                  height: 24,
                  child: new Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ic_arrow_black.png',
                        width: 14,
                        height: 14,
                      ),
                    ],
                  ),
                  onPressed: () {
                    _onSelectDate(context);
                  },
                ))
          ],
        )),
      ),
    );
  }

  Widget _buildTime(BuildContext context, String title, String date) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 10),
        height: 24,
        child: InkWell(
            child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _buildSubItem(title),
            _buildSubItem2(date),
          ],
        )),
      ),
    );
  }



  Widget _item(Map<String, dynamic> item) {
    String label = item['label'];
    String value = item['value'].toString();
    String relativeRatio =
        (NumUtil.getNumByValueDouble(item['relativeRatio'], 2))
                .toStringAsFixed(2) +
            '%';
    return FractionallySizedBox(
        widthFactor: 1.0,
        child: Container(
          height: 24,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _buildSubItem(label),
              _buildSubItem2(value),
              _buildSubItem3(relativeRatio),
            ],
          ),
        ));
  }

  Widget _buildTitle(String s) {
    return Container(
        height: 24,
        child: Text(s,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.green,
              //字体颜色
              fontSize: 14.0,
              //字体大小，注意flutter里面是double类型
              fontWeight: FontWeight.bold,
            )));
  }

  Widget _buildSubItem(String s) {
    return Container(
        height: 24,
        width: 140,
        child: Text(s,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black87,
              //字体颜色
              fontSize: 14.0,
              //字体大小，注意flutter里面是double类型
              fontWeight: FontWeight.bold,
            )));
  }

  Widget _buildSubItem2(String s) {
    return Container(
        height: 24,
        width: 100,
        child: Text(
          s,
          textAlign: TextAlign.start,
        ));
  }

  Widget _buildSubItem3(String s) {
    return Container(
        height: 24,
        width: 100,
        child: Text(s,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.red,
              //字体颜色
              fontSize: 14.0,
              //字体大小，注意flutter里面是double类型
            )));
  }


}

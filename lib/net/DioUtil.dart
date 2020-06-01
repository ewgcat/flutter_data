import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';

final logger = Logger();

class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}
class DioUtil {
  static final DioUtil _instance = DioUtil._init();
  static Dio _dio;
  static BaseOptions _options = getDefOptions();
  static String baseUrl = "https://jiaomigo.gialen.com/";

  factory DioUtil() {
    return _instance;
  }

  DioUtil._init() {
    _dio = new Dio();
    // 添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      logger.d("================== 请求数据 ==========================\n" +
          "url = ${options.uri.toString()}\n" +
          "headers = ${options.headers}\n" +
          "params = ${options.queryParameters}\n" +
          "data = ${options.data}\n");
    }, onResponse: (Response response) {
      logger.d("================== 响应数据 ==========================\n" +
          "code = ${response.statusCode}\n" +
          "data = ${response.data}\n");
    }, onError: (DioError e) {
      logger.d("================== 错误响应数据 ==========================\n" +
          "type = ${e.type}\n" +
          "message = ${e.message}\n" +
          "error = ${e.error}\n");
    }));
    _dio.options = getDefOptions();
  }

  static BaseOptions getDefOptions() {
    BaseOptions options = BaseOptions();
    options.baseUrl = baseUrl;
    options.connectTimeout = 5 * 1000;
    options.receiveTimeout = 5 * 1000;
    options.contentType = "application/json";

    Map<String, dynamic> headers = Map<String, dynamic>();
    headers['Accept'] = 'application/json';

    String platform;
    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "IOS";
    }
    headers['OS'] = platform;
    options.headers = headers;

    return options;
  }

  setOptions(BaseOptions options) {
    _options = options;
    _dio.options = _options;
  }

  Future<Map<String, dynamic>> get(String path,
      {pathParams, data, Function errorCallback}) {
    return request(path,
        method: Method.get,
        pathParams: pathParams,
        errorCallback: errorCallback);
  }

  Future<Map<String, dynamic>> post(String path,
      {pathParams, data, Function errorCallback}) {
    return request(path,
        method: Method.post,
        pathParams: pathParams,
        data: data,
        errorCallback: errorCallback);
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
  
  Future<Map<String, dynamic>> request(String path,
      {String method, Map pathParams, data, Function errorCallback}) async {
    if (pathParams != null) {
      path=path+"?";
      pathParams.forEach((key, value) {
        path = path+"$key="+ value.toString()+"&";
      });
    }

    Response response;
    try {
      response = await _dio.request(path,
          data: data, options: Options(method: method));
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        try {
          if (response.data is Map) {
            Map  data=    response.data;
            return data;
          }
        } catch (e) {
          _handleHttpError(e);
          errorCallback(response.data);
          return null;
        }
      } else {
        if (errorCallback != null) {
          errorCallback(response.data);
        }
        return null;
      }
    } catch (e) {
      errorCallback(e.toString());
      _handleHttpError(e);
    }
  }

  ///处理Http错误码
  void _handleHttpError(Exception exception) {
    if (exception is DioError) {
      Fluttertoast.showToast(
          msg: "网络连接错误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          bgcolor: "#9E9E9E",
          textcolor: '#ffffff');
    }
  }
}

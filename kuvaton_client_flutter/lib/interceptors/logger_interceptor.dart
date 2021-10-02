import 'package:http_interceptor/http_interceptor.dart';

class LoggerInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('=== REQUEST ===');
    print('encoding: ${data.encoding}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    print('===============\n\n');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('=== RESPONSE ===');
    print('status: ${data.statusCode}');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    print('===============\n\n');
    return data;
  }
}

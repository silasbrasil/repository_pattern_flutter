import 'package:repositories_management/config.dart';
import 'package:repositories_management/exceptions/api_exception.dart';
import 'package:http/http.dart' as http;

class UserApiRepository {
  Future<String> get() async {
    final response = await http.get(Url.apiV1);

    if (response.statusCode == HttpStatusCode.Ok) return response.body;

    throw handlerHttpException(response);
  }

  Future<String> post() async {
    final response = await http.get(Url.apiV1);

    if (response.statusCode == HttpStatusCode.Created) return response.body;

    throw handlerHttpException(response);
  }

  Future<String> put() async {
    final response = await http.get(Url.apiV1);

    if (response.statusCode == HttpStatusCode.Ok ||
        response.statusCode == HttpStatusCode.Accepted ||
        response.statusCode == HttpStatusCode.NoContent) return response.body;

    throw handlerHttpException(response);
  }

  Future<String> delete() async {
    final response = await http.get(Url.apiV1);

    if (response.statusCode == HttpStatusCode.Ok ||
        response.statusCode == HttpStatusCode.Accepted ||
        response.statusCode == HttpStatusCode.NoContent) return response.body;

    throw handlerHttpException(response);
  }
}

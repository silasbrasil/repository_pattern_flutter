import 'dart:convert';

import 'package:http/http.dart' as http;

/// Interface para as exceções http
abstract class ApiException {
  final http.Response _response;
  ApiException(this._response);

  String get message;
  int get code;
}

/// Tipo de status code
class HttpStatusCode {
  static const Ok = 200;
  static const Created = 201;
  static const Accepted = 202;
  static const NoContent = 204;
  static const BadRequest = 400;
  static const Unauthorized = 401;
  static const Timeout = 408;
  static const InternalServerError = 500;
}

/// Classes para cada tipo de exceção
class BadRequest implements ApiException {
  final http.Response _response;
  BadRequest(this._response);

  String get message => jsonDecode(_response.body)['detail'] as String;
  int get code => _response.statusCode;
}

class Unauthorized implements ApiException {
  final http.Response _response;
  Unauthorized(this._response);

  String get message => jsonDecode(_response.body)['detail'] as String;
  int get code => _response.statusCode;
}

class Timeout implements ApiException {
  final http.Response _response;
  Timeout(this._response);

  String get message => jsonDecode(_response.body)['detail'] as String;
  int get code => _response.statusCode;
}

/// [OBS]
/// Nesse caso, eu não sei onde vem a mensagem de erro,
/// mas acho que é no campo [message] do [body]
class InternalServerError implements ApiException {
  final http.Response _response;
  InternalServerError(this._response);

  String get message => jsonDecode(_response.body)['message'] as String;
  int get code => _response.statusCode;
}

/// Retorna a classe correspondente ao erro ocorrido
ApiException handlerHttpException (http.Response response) {
  switch(response.statusCode) {
    case HttpStatusCode.BadRequest:
      return BadRequest(response);
      break;

    case HttpStatusCode.Unauthorized:
      return Unauthorized(response);
      break;

    case HttpStatusCode.Timeout:
      return Timeout(response);
      break;

    case HttpStatusCode.InternalServerError:
      return InternalServerError(response);
      break;
  }
}
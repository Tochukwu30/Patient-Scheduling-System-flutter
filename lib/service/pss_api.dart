import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pss/constants/pss_api.dart';
import 'package:pss/models/access_token.dart';
import 'package:pss/models/bio_doctor.dart';
import 'package:pss/models/bio_patient.dart';

class ApiResponse {
  //statuscode will hold status code of response
  int? statusCode;
  // _data will hold any response converted into
  // its own object. For example user.
  Object? _data;
  // _apiError will hold the error object
  Object? _apiError;

  // ignore: unnecessary_getters_setters, non_constant_identifier_names
  Object? get Data => _data;
  // ignore: non_constant_identifier_names
  set Data(Object? data) => _data = data;

  // ignore: non_constant_identifier_names
  Object get ApiError => _apiError as Object;
  // ignore: non_constant_identifier_names
  set ApiError(Object error) => _apiError = error;

  bool hasData() {
    return _data != null;
  }
}

class ApiError {
  int? _statusCode;
  String? _error;

  ApiError({statusCode, error}) {
    _statusCode = statusCode;
    _error = error;
  }

  // ignore: unnecessary_getters_setters
  String? get error => _error;
  set error(String? error) => _error = error;

  ApiError.fromJson(
      {required int statusCode, required Map<String, dynamic> json}) {
    _statusCode = statusCode;
    _error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = _statusCode;
    data['error'] = _error;
    return data;
  }
}

Future<ApiResponse> authenticateUser(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('${PSSApiConstants.baseUrl}auth/token/'),
      body: {
        'email': email,
        'password': password,
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data = AccessToken.fromJson(json.decode(response.body));
        await SessionManager().set("token", (apiResponse.Data as AccessToken));
        break;
      case 401:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
      default:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
    }
  } on SocketException {
    apiResponse.ApiError = ApiError(
      error: "Server error. Please retry",
    );
  }
  return apiResponse;
}

Future<ApiResponse> registerUser({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  required String role,
}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('${PSSApiConstants.baseUrl}auth/signup/'),
      body: {
        "first_name": firstName,
        "last_name": lastName,
        'email': email,
        'password': password,
        'role': role
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 201:
        apiResponse.Data = json.decode(response.body);
        // await SessionManager().set("token", (apiResponse.Data as AccessToken));
        break;
      case 401:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
      default:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
    }
  } on SocketException {
    apiResponse.ApiError = ApiError(
      error: "Server error. Please retry",
    );
  }
  return apiResponse;
}

// Get User biodata for either Doctor or Patient
Future<ApiResponse> getBio() async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.get(
      Uri.parse('${PSSApiConstants.baseUrl}auth/bio/'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${token.access}"},
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        switch (token.role) {
          case "Doctor":
            apiResponse.Data = BioDoctor.fromJson(json.decode(response.body));
            break;
          case "Patient":
            apiResponse.Data = BioPatient.fromJson(json.decode(response.body));
            break;
          default:
            apiResponse.ApiError = ApiError(
              error: "Invalid User. Please retry",
            );
        }
        break;

      case 401:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
      default:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
    }
  } on SocketException {
    apiResponse.ApiError = ApiError(
      error: "Server error. Please retry",
    );
  }
  return apiResponse;
}

// Set user bio
Future<ApiResponse> updateBio({
  String? firstName,
  String? lastName,
  String? phoneNumber,
  String? email,
  String? speciality,
  String? homeAddress,
  String? officeAddress,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));
  final Map<String, dynamic> bio = <String, dynamic>{};
  bio["first_name"] = firstName;
  bio["last_name"] = lastName;
  bio["phone_no"] = phoneNumber;
  bio["email"] = email;
  bio["home_address"] = homeAddress;
  switch (token.role) {
    case "Doctor":
      bio["speciality"] = speciality;
      bio["office_address"] = officeAddress;
      break;
  }

  try {
    final response = await http.patch(
      Uri.parse('${PSSApiConstants.baseUrl}auth/bio/'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${token.access}"},
      body: bio,
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        switch (token.role) {
          case "Doctor":
            apiResponse.Data = BioDoctor.fromJson(json.decode(response.body));
            break;
          case "Patient":
            apiResponse.Data = BioPatient.fromJson(json.decode(response.body));
            break;
        }
        break;

      case 401:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
      default:
        try {
          apiResponse.ApiError = ApiError.fromJson(
            statusCode: response.statusCode,
            json: json.decode(response.body),
          );
        } catch (e) {
          apiResponse.ApiError = ApiError(
            statusCode: response.statusCode,
            error: "Unknown error",
          );
        }
        break;
    }
  } on SocketException {
    apiResponse.ApiError = ApiError(
      error: "Server error. Please retry",
    );
  }
  return apiResponse;
}

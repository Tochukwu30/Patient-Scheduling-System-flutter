// Get all doctors
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/service/pss_api.dart';

import '../constants/pss_api.dart';
import '../models/access_token.dart';
import '../models/doctors_list.dart';

Future<ApiResponse> getDoctors({
  String? firstName,
  String? lastName,
  String? email,
  String? speciality,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.post(
      Uri.parse(
        '${PSSApiConstants.baseUrl}auth/doctors/',
      ),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
      body: json.encode({
        "first_name__icontains": firstName,
        "last_name__icontains": lastName,
        "email__icontains": email,
        "speciality__icontains": speciality,
      }),
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            DoctorsListResult.fromJson(json.decode(response.body));
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

// Fetch next page of doctors
Future<ApiResponse> getNextDoctors({
  required String next,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.get(
      Uri.parse(next),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            DoctorsListResult.fromJson(json.decode(response.body));
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

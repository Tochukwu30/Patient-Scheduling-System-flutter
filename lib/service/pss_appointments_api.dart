// Get all patients
import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/models/appointment.dart';
import 'package:pss/service/pss_api.dart';
import 'package:http/http.dart' as http;

import '../constants/pss_api.dart';
import '../models/access_token.dart';

Future<ApiResponse> getAppointments() async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.get(
      Uri.parse('${PSSApiConstants.baseUrl}appointments/'),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            AppointmentsListResult.fromJson(json.decode(response.body));
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

Future<ApiResponse> getNextAppointments({
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
            AppointmentsListResult.fromJson(json.decode(response.body));
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

// Create appointment
Future<ApiResponse> createAppointments({
  required DateTime dateTime,
  String? description,
  required int doctor,
  required int patient,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.post(
      Uri.parse('${PSSApiConstants.baseUrl}appointments/create/'),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
      body: json.encode({
        "datetime": dateTime.toUtc().toString(),
        "description": description,
        "doctor": doctor,
        "patient": patient,
      }),
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 201:
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

// Update appointment
Future<ApiResponse> updateAppointment({
  required int id,
  required String status,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.patch(
      Uri.parse('${PSSApiConstants.baseUrl}appointments/update/'),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
      body: json.encode({
        "id": id,
        "status": status,
      }),
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
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

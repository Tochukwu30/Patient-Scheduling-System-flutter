// Get all patients
import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/models/chat.dart';
import 'package:pss/service/pss_api.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../constants/pss_api.dart';
import '../models/access_token.dart';

Future<ApiResponse> getChatList() async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.get(
      Uri.parse('${PSSApiConstants.baseUrl}chats/'),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data = ChatsListResult.fromJson(json.decode(response.body));
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

Future<ApiResponse> getNextChats({
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
        apiResponse.Data = ChatsListResult.fromJson(json.decode(response.body));
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

Future<ApiResponse> getMessages({
  required int id,
}) async {
  ApiResponse apiResponse = ApiResponse();
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));

  try {
    final response = await http.get(
      Uri.parse('${PSSApiConstants.baseUrl}chats/${id.toString()}/'),
      headers: {
        "content-Type": "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${token.access}"
      },
    );
    apiResponse.statusCode = response.statusCode;

    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            MessagesListResult.fromJson(json.decode(response.body));
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

Future<ApiResponse> getNextMessages({
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
            MessagesListResult.fromJson(json.decode(response.body));
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

Future<IOWebSocketChannel> connectWebSocket({required int userId}) async {
  final AccessToken token =
      AccessToken.fromJson(await SessionManager().get("token"));
  return IOWebSocketChannel.connect(
    Uri.parse('${PSSApiConstants.webSocketUrl}${userId.toString()}'),
    headers: {
      "content-Type": "application/json; charset=utf-8",
      HttpHeaders.authorizationHeader: "Bearer ${token.access}"
    },
  );
}

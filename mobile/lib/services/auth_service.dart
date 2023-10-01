import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/dto/get_token_dto.dart';
import 'api/result.dart';

class AuthService {
  Future<Result<String>> obtainToken(String login, String password) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    log('Obtaining token');

    try {
      Response response = await GetIt.I<Dio>().post(
          'http://kokoc.flint3s.ru/api/auth/login',
          data: jsonEncode({'login': login, 'password': password})
      );

      GetTokenDto data = GetTokenDto.fromJson(response.data);
      int? statusCode = response.statusCode;

      if (statusCode == 200 && data.accessToken != null) {
        sp.setBool('isSignedIn', true);
        sp.setString('authToken', data.accessToken!);
        sp.setInt('userId', response.data['user']['id']!);

        GetIt.I<Dio>().options.headers['Authorization'] =
            'Bearer ${data.accessToken!}';

        Response employeeResponse = await GetIt.I<Dio>().post(
            'http://kokoc.flint3s.ru/api/auth/check',
            data: jsonEncode({'accessToken': data.accessToken!})
        );

        if (employeeResponse.data?['employee'] != null) {
          sp.setInt('employeeId', employeeResponse.data?['employee']['id']!);
        } else {
          sp.setBool('isSignedIn', false);
          sp.remove('authToken');

          log('Error while obtaining token');
          return Result.error('Ошибка аутентификации: пользователь не является сотрудником. Используйте веб-версию');
        }

        log('Token obtained');
        return Result.success(data.accessToken!);
      } else {
        sp.setBool('isSignedIn', false);
        sp.remove('authToken');

        log('Error while obtaining token');
        return Result.error('Ошибка аутентификации: ${data.detail}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data != null) {
          sp.setBool('isSignedIn', false);
          sp.remove('authToken');

          GetTokenDto data = GetTokenDto.fromJson(e.response?.data);
          log('Error while obtaining token');
          return Result.error('Ошибка аутентификации: ${data.detail}');
        }
      }

      log('Error while obtaining token');
      return Result.error('Ошибка аутентификации: $e');
    }
  }

  Future<bool> isSignedIn() async {
    log('Get isSignedIn: ${(await SharedPreferences.getInstance()).getBool('isSignedIn')}');
    return (await SharedPreferences.getInstance()).getBool('isSignedIn') ??
        false;
  }

  Future<bool> isTokenValid() async {
    log('Checking is token valid');
    String? token =
        (await SharedPreferences.getInstance()).getString('authToken');

    if (token == null || !await isSignedIn()) {
      log('Token not found or is not signed in');
      return false;
    }

    try {
      Response response = await GetIt.I<Dio>()
          .get(
              'https://run.mocky.io/v3/fd01630d-b433-4ee1-af1c-45822a101dba'); //202

      if (response.data['valid'] == 'true') {
        log('Token is valid');
        GetIt.I<Dio>().options.headers['Authorization'] = 'Bearer $token';
        return true;
      }
    } catch (e) {}

    log('Token is NOT valid');
    return false;
  }
}

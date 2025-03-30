import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:realconnect_ui/providers/api_service_provider.dart';
import '../services/api_service.dart';

// Example states
enum ApiStatus { idle, loading, success, error }

class ApiController extends StateNotifier<ApiStatus> {
  final ApiService apiService;

  ApiController(this.apiService) : super(ApiStatus.idle);

  Future<String?> registerUser(Map<String, dynamic> data) async {
    state = ApiStatus.loading;

    try {
      final response = await apiService.post('api-auth/register/', data);

      if (response.statusCode == 201) {
        state = ApiStatus.success;
        return null;
      } else {
        state = ApiStatus.error;
        return 'Registration failed';
      }
    } on DioException catch (e) {
      state = ApiStatus.error;
      return e.response?.data['detail'] ?? 'An error occurred';
    }
  }

  void resetStatus() {
    state = ApiStatus.idle;
  }

  Future<String?> activateUser(Map<String, dynamic> data) async {
    state = ApiStatus.loading;

    try {
      final response = await apiService.post('api-auth/activate/', data);

      if (response.statusCode == 200) {
        state = ApiStatus.success;
        return null;
      } else {
        state = ApiStatus.error;
        return 'Registration failed';
      }
    } on DioException catch (e) {
      state = ApiStatus.error;
      return e.response?.data['detail'] ?? 'An error occurred';
    }
  }

  Future<String?> login(Map<String, dynamic> data) async {
    state = ApiStatus.loading;

    try {
      final response = await apiService.post('api-auth/token', data);

      if (response.statusCode == 200) {
        state = ApiStatus.success;
        final refresh = response.data['access'];
        final token = response.data['refresh'];
        apiService.saveToken(refresh, 'jwt_token');
        apiService.saveToken(token, 'refresh_token');
        return null;
      } else {
        state = ApiStatus.error;
        return 'Login Failed';
      }
    } on DioException catch (e) {
      state = ApiStatus.error;
      return e.response?.data['detail'] ?? 'An error occurred';
    }
  }
}

// Controller Provider
final apiControllerProvider =
    StateNotifierProvider<ApiController, ApiStatus>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ApiController(apiService);
});

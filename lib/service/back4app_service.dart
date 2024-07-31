import 'package:dio/dio.dart';

class Back4AppService {
  final Dio _dio;

  Back4AppService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://parseapi.back4app.com/classes',
          headers: {
            'X-Parse-Application-Id': 'SUA_APLICATION_ID',
            'X-Parse-REST-API-Key': 'SUA_API_KEY',
          },
        ));
        
  Future<List<dynamic>> fetchTasks() async {
    final response = await _dio.get('/SUA_CLASSE');
    return response.data['results'];
  }

  Future<Map<String, dynamic>?> addTask(String title, String description, bool completed) async {
    try {
      final response = await _dio.post('/SUA_CLASSE', data: {
        'title': title,
        'description': description,
        'completed': completed,
      });
      if (response.data != null) {
        return {
          'objectId': response.data['objectId'],
          'title': title,
          'description': description,
          'completed': completed,
        };
      }
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
    }
    return null;
  }

  Future<void> updateTaskStatus(String objectId, bool completed) async {
    try {
      await _dio.put('/SUA_CLASSE/$objectId', data: {
        'completed': completed,
      });
    } catch (e) {
      print('Erro ao atualizar status da tarefa: $e');
    }
  }
}
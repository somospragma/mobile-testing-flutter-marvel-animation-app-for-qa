// Este archivo es para probar la carga de imágenes con la nueva implementación
// Puedes ejecutarlo como una herramienta de diagnóstico

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/constants/network_paths.dart';

class ImageLoadingTest {
  static Future<void> testImageLoading(int heroId) async {
    final dio = Dio();
    
    try {
      // 1. Probar la URL directa de la API
      final directResponse = await dio.get(getHeroPath(heroId));
      final directImageUrl = directResponse.data['image']['url'];
      print('URL directa de imagen: $directImageUrl');
      
      // 2. Probar la URL del endpoint específico de imagen
      final imageEndpointUrl = getHeroImagePath(heroId);
      final imageResponse = await dio.get(imageEndpointUrl);
      final endpointImageUrl = imageResponse.data['url'];
      print('URL del endpoint de imagen: $imageEndpointUrl');
      print('URL de imagen desde endpoint: $endpointImageUrl');
      
      // 3. Verificar si las URLs son iguales
      print('¿Las URLs son iguales? ${directImageUrl == endpointImageUrl}');
      
      // 4. Verificar si las imágenes son accesibles
      try {
        await dio.head(directImageUrl);
        print('URL directa accesible: SÍ');
      } catch (e) {
        print('URL directa accesible: NO - ${e.toString()}');
      }
      
      try {
        await dio.head(endpointImageUrl);
        print('URL del endpoint accesible: SÍ');
      } catch (e) {
        print('URL del endpoint accesible: NO - ${e.toString()}');
      }
      
    } catch (e) {
      print('Error en la prueba: ${e.toString()}');
    }
  }
}

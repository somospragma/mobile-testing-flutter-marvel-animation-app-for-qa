// Este archivo es para verificar las URLs generadas

import 'package:flutter/material.dart';
import '../../../core/utils/constants/network_paths.dart';
import '../../../core/env/config_env.dart';

class UrlVerificationTest extends StatelessWidget {
  const UrlVerificationTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener las URLs para el héroe con ID 1
    final heroPath = getHeroPath(1);
    final heroImagePath = getHeroImagePath(1);
    final searchPath = getSearchPath("batman");
    
    // Obtener valores directos del entorno
    final env = ConfigENV.intance.getAppEnv;
    final apiUrl = env.apiUrl;
    final apiToken = env.apiToken;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('API URL: $apiUrl', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('API Token: $apiToken'),
            const SizedBox(height: 16),
            Text('Hero Path: $heroPath'),
            const SizedBox(height: 8),
            Text('Hero Image Path: $heroImagePath'),
            const SizedBox(height: 8),
            Text('Search Path: $searchPath'),
            const SizedBox(height: 32),
            const Text('Image Test:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImageTest(1, context),
                    _buildImageTest(2, context),
                    _buildImageTest(3, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageTest(int heroId, BuildContext context) {
    final imageUrl = getHeroImagePath(heroId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hero ID: $heroId', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('URL: $imageUrl'),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('Error: ${error.toString()}', 
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

`<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="https://f.hubspotusercontent20.net/hubfs/2829524/Copia%20de%20LOGOTIPO_original-2.png"></a>
  <br>
  Clean Architecture App
  <br>
</h1>

<h4 align="center">Proyecto base de <a href="https://github.com/karatelabs/karate" target="_blank">Pragma</a>.</h4>

<p align="center">
  <a href="https://docs.flutter.dev/release/archive">
    <img src="https://img.shields.io/badge/Flutter-3.29.0-blue" alt="Flutter">
  </a>
  <a href="https://riverpod.dev/es/">
    <img src="https://img.shields.io/badge/Riverpod-purple" alt="Riverpod">
  </a>
</p>

Este proyecto es un arquetipo base para aplicaciones Flutter implementadas con Clean Architecture. Está diseñado para facilitar el desarrollo siguiendo las mejores prácticas, como la separación de responsabilidades, el uso de Repository Pattern y la gestión de estado con Riverpod.

<p align="center">
  <a href="#topicos">Topicos</a> •`
  <a href="#tecnologias">Tecnologias</a> •
  <a href="#descarga">Descarga</a> •
  <a href="#instalación-y-ejecución">Instalación y ejecución</a> •
  <a href="#autores">Autores</a> •
</p>

## Topicos

* Flutter
* Riverpod

## Tecnologias
### This project required:
- [SDK Flutter] version 3.29.0
- [Dart] version 3.7.0
- [Riverpod] version 2.6.1

## Descarga
Para clonar está aplicación desde la linea de comando:

```bash
git clone https://github.com/sharfe25/marvel_animation_app.git
cd marvel_animation_app
git remote remove origin
git remote add origin URL_DE_TU_NUEVO_REPOSITORIO
git push -u origin master
```
Nota: Asegúrate de reemplazar URL_DE_TU_NUEVO_REPOSITORIO con la URL del repositorio que creaste en tu cuenta de GitHub.

Puedes descargar el proyecto en el enlace [download](https://github.com/sharfe25/marvel_animation_app) 

## Instalación y ejecución

Para ejecutar está aplicación, necesitas [Java JDK](https://www.oracle.com/java/technologies/downloads/) y [Flutter SDK](https://docs.flutter.dev/release/archive) instalados en tu equipo, ten en cuenta que tu IDE puede gestionar la instalación de estos requerimientos. Desde la linea de comando:

### Instalar dependencias
```bash
   flutter pub get
   ```
 ### Ejecutar la aplicación
```bash
   flutter run
   ```
## Riverpod como gestor de estado en Flutter

### ¿Qué es Riverpod?

Riverpod es un gestor de estado para Flutter que se basa en el concepto de proveedores (*providers*). Fue creado por Remi Rousselet, el mismo autor de `provider`, pero con una arquitectura más robusta, segura y flexible.

A diferencia de `provider`, Riverpod es independiente del *BuildContext*, lo que permite un mejor manejo del estado global y facilita la depuración.

### Principales ventajas de Riverpod

✅ **No depende de **: Puedes acceder al estado en cualquier parte de la app sin necesidad de un ``BuildContext``. 
✅ **Seguridad en el acceso al estado**: Riverpod detecta automáticamente si se intenta acceder a un estado antes de que esté disponible. 
✅ **Optimización de rendimiento**: Solo se reconstruyen los widgets que dependen de un estado específico. 
✅ **Escalabilidad**: Facilita la gestión del estado en proyectos grandes con múltiples capas (UI, dominio, infraestructura).

---

### Tipos de proveedores (*Providers*) en Riverpod

Los *providers* son la base de Riverpod y se utilizan para definir el estado y la lógica de negocio de la aplicación.

#### 1. `Provider`: Para valores inmutables o de solo lectura

Se usa para exponer valores estáticos o resultados de cálculos sin estado.

```dart
final greetingProvider = Provider<String>((ref) => 'Hola, Riverpod!');

class GreetingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    return Text(greeting);
  }
}
```

---

#### 2. `StateProvider`: Para estados simples y mutables

Permite manejar estados simples como `bool`, `int`, `String`, etc.

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Column(
      children: [
        Text('Contador: $counter'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Incrementar'),
        ),
      ],
    );
  }
}
```

---

#### 3. `StateNotifierProvider`: Para lógica de negocio compleja

Se usa cuando el estado es más complejo y necesita métodos para actualizarse.

```dart
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
}

final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifierWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterNotifierProvider);
    return Column(
      children: [
        Text('Contador: $counter'),
        ElevatedButton(
          onPressed: () => ref.read(counterNotifierProvider.notifier).increment(),
          child: Text('Incrementar'),
        ),
      ],
    );
  }
}
```

---

#### 4. `FutureProvider`: Para datos asíncronos (API, BD, etc.)

Se usa para manejar datos obtenidos de una API o base de datos de manera asíncrona.

```dart
final userProvider = FutureProvider<User>((ref) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));
  return User.fromJson(jsonDecode(response.body));
});

class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return user.when(
      data: (user) => Text('Usuario: ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

---

#### 5. `StreamProvider`: Para escuchar cambios en tiempo real

Se usa para obtener datos en tiempo real, como Firestore o WebSockets.

```dart
final timeProvider = StreamProvider<int>((ref) async* {
  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield DateTime.now().second;
  }
});

class TimeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeProvider);
    
    return time.when(
      data: (value) => Text('Segundos: $value'),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

---

### Cómo usar Riverpod en una aplicación Flutter

#### 1. Agregar la dependencia en `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
```

#### 2. Envolver la aplicación con `ProviderScope`

Para que los *providers* estén disponibles en toda la app, envuelve tu `MaterialApp` con `ProviderScope`.

```dart
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

---

### Diferencia entre `ref.watch()`, `ref.read()` y `ref.listen()`

| Método                           | Uso                                                             |
| -------------------------------- | --------------------------------------------------------------- |
| `ref.watch(provider)`            | Obtiene el valor y se reconstruye cuando cambia.                |
| `ref.read(provider)`             | Obtiene el valor una sola vez y no se reconstruye.              |
| `ref.listen(provider, callback)` | Escucha cambios y ejecuta una acción sin reconstruir el widget. |

Ejemplo de `ref.listen()` para mostrar un *SnackBar* en caso de error:

```dart
ref.listen<AsyncValue<User>>(userProvider, (_, state) {
  if (state.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar usuario')),
    );
  }
});
```


## Autores


 [<img src="https://avatars.githubusercontent.com/u/51301940?s=400&u=59904da5265ef21c498b68373ed0bdb3f2c16127&v=4" width=115><br><sub>Sharon Y. Rueda F.</sub>](https://github.com/sharfe25) <br/> 


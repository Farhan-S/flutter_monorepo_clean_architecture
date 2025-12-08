# Features Splash

Splash screen feature module following Clean Architecture principles.

## Features

- ✅ App initialization logic
- ✅ Authentication status check
- ✅ Automatic navigation (home/login)
- ✅ Smooth fade animations
- ✅ Error handling with user feedback
- ✅ Clean Architecture (Domain/Data/Presentation)

## Structure

```
lib/
├── domain/
│   ├── entities/
│   │   └── app_init_entity.dart
│   ├── repositories/
│   │   └── app_initialization_repository.dart
│   └── usecases/
│       ├── initialize_app_usecase.dart
│       └── check_auth_status_usecase.dart
├── data/
│   ├── models/
│   │   └── app_init_model.dart
│   ├── datasources/
│   │   └── app_init_datasource.dart
│   └── repositories/
│       └── app_initialization_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── splash_bloc.dart
    │   ├── splash_event.dart
    │   └── splash_state.dart
    └── pages/
        └── splash_page.dart
```

## Usage

### 1. Add to app dependencies

```yaml
dependencies:
  features_splash:
    path: ../features_splash
```

### 2. Register in DI container

```dart
// Splash
sl.registerFactory(() => AppInitDataSource(sl()));
sl.registerFactory<AppInitializationRepository>(
  () => AppInitializationRepositoryImpl(sl()),
);
sl.registerFactory(() => InitializeAppUseCase(sl()));
sl.registerFactory(() => CheckAuthStatusUseCase(sl()));
sl.registerFactory(
  () => SplashBloc(
    initializeAppUseCase: sl(),
    checkAuthStatusUseCase: sl(),
  ),
);
```

### 3. Register splash route

```dart
AppRouteRegistry.registerRoute(
  AppRoutes.splash,
  (settings) => MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => getIt<SplashBloc>(),
      child: const SplashPage(),
    ),
    settings: settings,
  ),
);
```

### 4. Set as initial route

```dart
MaterialApp(
  initialRoute: AppRoutes.splash, // Instead of AppRoutes.home
  onGenerateRoute: AppRouteGenerator.onGenerateRoute,
);
```

## Navigation Flow

```
SplashPage (Initializing...)
    ↓
Check Auth Status
    ↓
    ├─→ Authenticated → Navigate to Home
    └─→ Not Authenticated → Navigate to Login
```

## Customization

### Change Splash Duration

Edit `app_init_datasource.dart`:

```dart
await Future.delayed(const Duration(seconds: 2)); // Change duration
```

### Customize UI

Edit `splash_page.dart`:

- Change app icon/logo
- Modify colors and theme
- Update app name and tagline
- Adjust animations

### Add Token Validation

Implement backend validation in `app_init_datasource.dart`:

```dart
Future<bool> verifyTokenWithBackend(String token) async {
  final dioClient = DioClient();
  try {
    await dioClient.get(ApiRoutes.validateToken);
    return true;
  } catch (e) {
    return false;
  }
}
```

## States

- `SplashInitial` - Initial state
- `SplashLoading` - App initialization in progress
- `SplashAuthenticated` - User is authenticated
- `SplashUnauthenticated` - User needs to login
- `SplashError` - Initialization failed

## Events

- `InitializeAppEvent` - Start app initialization
- `CheckAuthStatusEvent` - Check authentication status

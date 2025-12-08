# Clean Architecture Implementation Guide

## 📐 Architecture Overview

This project follows **Clean Architecture** principles with **BLoC** state management pattern.

```
┌─────────────────────────────────────────────────┐
│             Presentation Layer                   │
│  (UI, BLoC, Pages, Widgets)                     │
│  └─> Flutter, flutter_bloc                      │
└──────────────┬──────────────────────────────────┘
               │
┌──────────────▼──────────────────────────────────┐
│              Domain Layer                        │
│  (Entities, Repositories, Use Cases)            │
│  └─> Pure Dart, no external dependencies        │
└──────────────┬──────────────────────────────────┘
               │
┌──────────────▼──────────────────────────────────┐
│               Data Layer                         │
│  (Models, Data Sources, Repository Impl)        │
│  └─> Dio, flutter_secure_storage                │
└──────────────┬──────────────────────────────────┘
               │
┌──────────────▼──────────────────────────────────┐
│               Core Layer                         │
│  (Network, Storage, Utilities)                  │
│  └─> DioClient, Interceptors, Exceptions        │
└─────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
lib/
├── core/                           # Shared infrastructure
│   ├── network/
│   │   ├── dio_client.dart         # Singleton HTTP client
│   │   ├── network_config.dart     # Environment config
│   │   ├── api_routes.dart         # Centralized routes
│   │   ├── api_response.dart       # Response wrapper & Result type
│   │   ├── api_exceptions.dart     # Exception hierarchy
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── refresh_token_interceptor.dart
│   │   │   ├── retry_interceptor.dart
│   │   │   ├── error_interceptor.dart
│   │   │   └── logging_interceptor.dart
│   │   └── utils/
│   │       └── multipart_helper.dart
│   ├── storage/
│   │   └── token_storage.dart      # Token management
│   └── services/                   # Legacy services (can be migrated)
│
├── domain/                         # Business logic layer
│   ├── entities/                   # Pure business objects
│   │   ├── user_entity.dart
│   │   └── auth_token_entity.dart
│   ├── repositories/               # Repository interfaces
│   │   ├── auth_repository.dart
│   │   └── user_repository.dart
│   └── usecases/                   # Business use cases
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── get_user_by_id_usecase.dart
│
├── data/                           # Data implementation layer
│   ├── models/                     # Data models (JSON serialization)
│   │   ├── user_model.dart
│   │   └── auth_token_model.dart
│   ├── datasources/
│   │   └── remote/
│   │       ├── auth_remote_datasource.dart
│   │       └── user_remote_datasource.dart
│   └── repositories/               # Repository implementations
│       ├── auth_repository_impl.dart
│       └── user_repository_impl.dart
│
├── presentation/                   # UI layer
│   └── features/
│       └── auth/
│           ├── bloc/
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           ├── pages/
│           │   └── login_page.dart
│           └── widgets/
│               └── login_form.dart
│
├── injection_container.dart        # Dependency injection setup
└── main.dart                       # App entry point
```

## 🎯 Key Principles

### 1. **Dependency Rule**

- **Dependencies point inward**: Outer layers depend on inner layers, never the reverse
- **Domain layer is pure**: No dependencies on Flutter or external packages
- **Data layer implements domain contracts**: Repository implementations in data layer

### 2. **Separation of Concerns**

```dart
// Domain defines WHAT to do
abstract class AuthRepository {
  Future<Either<ApiException, AuthTokenEntity>> login({...});
}

// Data defines HOW to do it
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  // Implementation details...
}

// Presentation uses it via BLoC
class AuthBloc {
  final LoginUseCase _loginUseCase; // Use case, not repository!
  // BLoC logic...
}
```

### 3. **Single Responsibility**

- Each use case has **one job**
- Each BLoC handles **one feature**
- Each repository manages **one resource**

## 🔄 Data Flow

### Login Example

```
User taps Login Button
        ↓
LoginPage (Widget)
        ↓
AuthBloc receives AuthLoginRequested event
        ↓
LoginUseCase.call(email, password)
        ↓
AuthRepository.login() [interface in domain]
        ↓
AuthRepositoryImpl.login() [implementation in data]
        ↓
AuthRemoteDataSource makes HTTP call via DioClient
        ↓
Returns Either<ApiException, AuthTokenModel>
        ↓
AuthRepositoryImpl saves tokens & converts Model → Entity
        ↓
LoginUseCase returns Either<ApiException, AuthTokenEntity>
        ↓
AuthBloc emits AuthAuthenticated(user) state
        ↓
LoginPage rebuilds UI based on state
```

## 🧩 Layer Responsibilities

### **Core Layer** (Infrastructure)

- ✅ DioClient singleton
- ✅ Interceptors (auth, retry, error, logging)
- ✅ Token storage interface
- ✅ API routes
- ✅ Exception hierarchy
- ❌ No business logic

### **Domain Layer** (Business Logic)

- ✅ Entities (pure Dart classes)
- ✅ Repository interfaces
- ✅ Use cases (single responsibility)
- ❌ No dependencies on external packages
- ❌ No Flutter imports

### **Data Layer** (Implementation)

- ✅ Models (JSON serialization)
- ✅ Data sources (API calls)
- ✅ Repository implementations
- ✅ Model ↔ Entity mapping
- ❌ No UI code

### **Presentation Layer** (UI)

- ✅ Pages & Widgets
- ✅ BLoC/Cubit for state management
- ✅ User interaction handling
- ❌ No direct API calls
- ❌ No business logic

## 🚀 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Initialize App

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

  // Initialize network layer
  _initializeNetworkLayer();

  runApp(const MyApp());
}
```

### 3. Provide BLoC

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
```

### 4. Use BLoC in Widget

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Show error message
        } else if (state is AuthAuthenticated) {
          // Navigate to home
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator();
        }
        return LoginForm();
      },
    );
  }
}
```

### 5. Dispatch Events

```dart
context.read<AuthBloc>().add(
  AuthLoginRequested(
    email: 'user@example.com',
    password: 'password123',
  ),
);
```

## 🎨 Adding New Features

### Step 1: Define Domain Layer

```dart
// 1. Create entity
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  // ...
}

// 2. Create repository interface
abstract class ProductRepository {
  Future<Either<ApiException, List<ProductEntity>>> getProducts();
}

// 3. Create use case
class GetProductsUseCase {
  final ProductRepository repository;
  Future<Either<ApiException, List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}
```

### Step 2: Implement Data Layer

```dart
// 1. Create model
class ProductModel extends ProductEntity {
  factory ProductModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  ProductEntity toEntity() {...}
}

// 2. Create data source
class ProductRemoteDataSource {
  final DioClient _dioClient;
  Future<List<ProductModel>> getProducts() async {
    final response = await _dioClient.get('/products');
    // ...
  }
}

// 3. Implement repository
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Either<ApiException, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
```

### Step 3: Create Presentation Layer

```dart
// 1. Define events
abstract class ProductEvent extends Equatable {}
class ProductsLoadRequested extends ProductEvent {}

// 2. Define states
abstract class ProductState extends Equatable {}
class ProductsLoading extends ProductState {}
class ProductsLoaded extends ProductState {
  final List<ProductEntity> products;
}
class ProductsError extends ProductState {
  final String message;
}

// 3. Create BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductBloc({required GetProductsUseCase getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase,
        super(ProductsLoading()) {
    on<ProductsLoadRequested>(_onProductsLoadRequested);
  }

  Future<void> _onProductsLoadRequested(...) async {
    emit(ProductsLoading());
    final result = await _getProductsUseCase();
    result.fold(
      (error) => emit(ProductsError(error.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}

// 4. Create UI
class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoading) return CircularProgressIndicator();
        if (state is ProductsError) return Text(state.message);
        if (state is ProductsLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (_, index) => ProductCard(state.products[index]),
          );
        }
        return Container();
      },
    );
  }
}
```

### Step 4: Register Dependencies

```dart
// In injection_container.dart
Future<void> setupDependencyInjection() async {
  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(getIt<DioClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductRepository>()),
  );

  // BLoC
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getProductsUseCase: getIt<GetProductsUseCase>()),
  );
}
```

## 🧪 Testing

### Unit Tests (Domain & Data)

```dart
// Test use case
test('LoginUseCase returns token on success', () async {
  // Arrange
  final mockRepository = MockAuthRepository();
  final useCase = LoginUseCase(mockRepository);

  when(mockRepository.login(email: any, password: any))
    .thenAnswer((_) async => Right(mockToken));

  // Act
  final result = await useCase(email: 'test@test.com', password: 'pass');

  // Assert
  expect(result.isRight(), true);
  expect(result.getOrElse(() => null), mockToken);
});
```

### BLoC Tests

```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () {
    when(mockLoginUseCase(email: any, password: any))
      .thenAnswer((_) async => Right(mockToken));
    when(mockGetCurrentUserUseCase())
      .thenAnswer((_) async => Right(mockUser));
    return AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
    );
  },
  act: (bloc) => bloc.add(AuthLoginRequested(
    email: 'test@test.com',
    password: 'password',
  )),
  expect: () => [
    AuthLoading(),
    AuthAuthenticated(mockUser),
  ],
);
```

## 📦 Key Packages

| Package                  | Purpose                              |
| ------------------------ | ------------------------------------ |
| `dio`                    | HTTP client                          |
| `flutter_bloc`           | State management                     |
| `get_it`                 | Dependency injection                 |
| `dartz`                  | Functional programming (Either type) |
| `equatable`              | Value equality                       |
| `flutter_secure_storage` | Secure token storage                 |
| `mockito`                | Testing                              |
| `bloc_test`              | BLoC testing                         |

## 🎯 Best Practices

1. **Use Either<L, R> for error handling** - No try-catch in UI
2. **Keep entities pure** - No JSON, no Flutter
3. **One use case per operation** - Single Responsibility
4. **BLoC per feature** - Not per screen
5. **Test business logic** - Domain & Data layers
6. **Mock at boundaries** - Repository interfaces
7. **Immutable states** - Use Equatable
8. **Factory for BLoC** - New instance each time
9. **Singleton for repositories** - Shared across app
10. **Dependency injection** - Never use `new` keyword

## 🔄 Migration Path

If you have existing services, gradually migrate them:

1. **Keep old code working** - Don't break existing features
2. **Create new features with Clean Architecture**
3. **Gradually refactor old code** - One feature at a time
4. **Move logic to use cases** - From services
5. **Replace direct API calls** - With repository pattern
6. **Add BLoC for new screens** - Replace setState

## 📚 Additional Resources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Dependency Injection in Flutter](https://pub.dev/packages/get_it)

---

**Happy Coding! 🚀**

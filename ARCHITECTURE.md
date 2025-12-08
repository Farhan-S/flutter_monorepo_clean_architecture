# Dio Network Config - Feature-Based Modular Architecture

A fully modular Flutter project demonstrating Clean Architecture with feature-based packages using Melos.

## 🏗️ Architecture Overview

This project follows a **feature-based modular architecture** where each feature is completely self-contained with its own domain, data, and presentation layers.

### Package Structure

```
packages/
├── core/                    # Shared infrastructure
│   ├── network/            # DioClient, interceptors, API routes
│   └── storage/            # Token storage, secure storage
│
├── features_auth/          # Authentication Feature Module
│   ├── domain/             # Business logic (pure Dart)
│   │   ├── entities/       # AuthTokenEntity
│   │   ├── repositories/   # AuthRepository interface
│   │   └── usecases/       # LoginUseCase, LogoutUseCase, GetCurrentUserUseCase
│   ├── data/               # Data layer implementation
│   │   ├── models/         # AuthTokenModel (Entity → Model mapping)
│   │   ├── datasources/    # AuthRemoteDataSource (API calls)
│   │   └── repositories/   # AuthRepositoryImpl
│   └── presentation/       # UI layer
│       ├── bloc/           # AuthBloc, AuthEvent, AuthState
│       ├── pages/          # LoginPage
│       └── widgets/        # LoginForm
│
├── features_user/          # User Feature Module
│   ├── domain/             # Business logic (pure Dart)
│   │   ├── entities/       # UserEntity
│   │   ├── repositories/   # UserRepository interface
│   │   └── usecases/       # GetUserByIdUseCase
│   ├── data/               # Data layer implementation
│   │   ├── models/         # UserModel
│   │   ├── datasources/    # UserRemoteDataSource
│   │   └── repositories/   # UserRepositoryImpl
│   └── presentation/       # UI layer (placeholder for future)
│       ├── bloc/           # UserBloc (to be implemented)
│       ├── pages/          # User profile pages (to be implemented)
│       └── widgets/        # User widgets (to be implemented)
│
└── app/                    # Main application
    ├── main.dart           # App entry point
    └── injection_container.dart  # Dependency injection setup
```

## 🎯 Key Principles

### 1. **Complete Feature Isolation**

- Each feature package is fully self-contained
- Features can be developed, tested, and maintained independently
- No shared domain or data layers across features

### 2. **Clean Architecture Layers**

Each feature follows Clean Architecture:

#### Domain Layer (Pure Business Logic)

- **Entities**: Core business objects (e.g., `UserEntity`, `AuthTokenEntity`)
- **Repositories**: Abstract interfaces defining contracts
- **Use Cases**: Single-responsibility business operations
- ✅ No dependencies on Flutter or external packages (except dartz, equatable)

#### Data Layer (Implementation Details)

- **Models**: Data transfer objects that extend entities
- **Data Sources**: API communication (Remote) or local storage
- **Repository Implementations**: Concrete implementations of domain repositories
- ✅ Depends on domain layer and core infrastructure

#### Presentation Layer (UI)

- **BLoC**: State management following BLoC pattern
- **Pages**: Full-screen views
- **Widgets**: Reusable UI components
- ✅ Depends on domain layer for business logic
- ✅ Uses flutter_bloc for reactive state management

### 3. **Dependency Rules**

```
Presentation → Domain ← Data
     ↓
   Core (Infrastructure)
```

- **Core**: No dependencies on features (only Flutter, Dio, storage)
- **Domain**: Only depends on core for exceptions
- **Data**: Depends on domain interfaces and core infrastructure
- **Presentation**: Depends on domain for business logic
- **App**: Orchestrates all features and handles DI

## 📦 Package Dependencies

### Core Package

```yaml
dependencies:
  - dio ^5.9.0
  - flutter_secure_storage ^9.2.2
  - shared_preferences ^2.3.3
```

### Feature Packages (Auth & User)

```yaml
dependencies:
  - core (local)
  - dartz ^0.10.1 # Functional programming
  - flutter_bloc ^8.1.6 # State management
  - equatable ^2.0.7 # Value equality
```

### App Package

```yaml
dependencies:
  - core (local)
  - features_auth (local)
  - features_user (local)
  - get_it ^8.0.2 # Dependency injection
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.9.2)
- Dart SDK
- Melos CLI (optional, for monorepo commands)

### Installation

1. **Install dependencies for all packages:**

   ```bash
   cd packages/core && flutter pub get
   cd ../features_user && flutter pub get
   cd ../features_auth && flutter pub get
   cd ../app && flutter pub get
   ```

2. **Or use Melos (if installed):**
   ```bash
   melos bootstrap
   ```

### Running the App

```bash
cd packages/app
flutter run
```

## 🛠️ Development Workflow

### Adding a New Feature

1. **Create feature package:**

   ```bash
   mkdir -p packages/features_<feature_name>/lib/{domain,data,presentation}
   ```

2. **Define domain layer:**

   - Create entities in `domain/entities/`
   - Define repository interfaces in `domain/repositories/`
   - Implement use cases in `domain/usecases/`

3. **Implement data layer:**

   - Create models in `data/models/`
   - Implement data sources in `data/datasources/`
   - Implement repositories in `data/repositories/`

4. **Build presentation layer:**

   - Create BLoC in `presentation/bloc/`
   - Build pages in `presentation/pages/`
   - Create widgets in `presentation/widgets/`

5. **Create barrel export:**

   ```dart
   // lib/features_<feature_name>.dart
   library features_<feature_name>;

   export 'domain/entities/...';
   export 'domain/repositories/...';
   export 'domain/usecases/...';
   export 'data/models/...';
   export 'data/datasources/...';
   export 'data/repositories/...';
   export 'presentation/bloc/...';
   export 'presentation/pages/...';
   export 'presentation/widgets/...';
   ```

6. **Update app dependencies:**

   ```yaml
   # packages/app/pubspec.yaml
   dependencies:
     features_<feature_name>:
       path: ../features_<feature_name>
   ```

7. **Register in DI container:**
   ```dart
   // packages/app/lib/injection_container.dart
   getIt.registerLazySingleton<FeatureRepository>(
     () => FeatureRepositoryImpl(...),
   );
   ```

## 🧪 Testing

Each feature can be tested independently:

```bash
# Test specific feature
cd packages/features_auth
flutter test

# Test all packages
melos run test
```

## 📊 Analysis

Run static analysis:

```bash
# Analyze specific package
cd packages/features_auth
flutter analyze

# Analyze all packages
melos run analyze
```

## 🎨 State Management

This project uses **BLoC (Business Logic Component)** pattern:

- **Events**: User actions or triggers
- **States**: UI states (loading, success, error)
- **BLoC**: Business logic that transforms events into states

Example:

```dart
// Feature exports BLoC, Events, and States
import 'package:features_auth/features_auth.dart';

// Usage in UI
BlocProvider<AuthBloc>(
  create: (context) => getIt<AuthBloc>(),
  child: LoginPage(),
)
```

## 🔐 Network Layer

Centralized in the `core` package:

- **DioClient**: Configured HTTP client
- **Interceptors**:
  - AuthInterceptor (adds tokens)
  - RefreshTokenInterceptor (refreshes expired tokens)
  - ErrorInterceptor (handles errors)
  - RetryInterceptor (retries failed requests)
  - LoggingInterceptor (logs requests/responses)
- **TokenStorage**: Secure token persistence

## 🔄 Data Flow

```
User Action (UI)
    ↓
  Event
    ↓
  BLoC (calls UseCase)
    ↓
UseCase (business logic)
    ↓
Repository Interface (domain)
    ↓
Repository Implementation (data)
    ↓
Data Source (API/Local)
    ↓
  Model
    ↓
  Entity
    ↓
  State
    ↓
UI Update
```

## 📝 Naming Conventions

- **Entities**: `<Name>Entity` (e.g., `UserEntity`)
- **Models**: `<Name>Model` (e.g., `UserModel`)
- **Repositories**: `<Name>Repository` (interface), `<Name>RepositoryImpl` (implementation)
- **Use Cases**: `<Action><Entity>UseCase` (e.g., `GetUserByIdUseCase`)
- **Data Sources**: `<Name>RemoteDataSource`, `<Name>LocalDataSource`
- **BLoC**: `<Feature>Bloc`, `<Feature>Event`, `<Feature>State`

## 🏆 Benefits of This Architecture

1. **Scalability**: Add features without affecting existing code
2. **Testability**: Each layer can be tested independently
3. **Maintainability**: Clear separation of concerns
4. **Reusability**: Features can be reused across projects
5. **Team Collaboration**: Multiple teams can work on different features
6. **Independence**: Features can be developed/deployed separately

## 📚 Additional Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC Package](https://bloclibrary.dev/)
- [Melos - Monorepo Management](https://melos.invertase.dev/)
- [Dio - HTTP Client](https://pub.dev/packages/dio)

## 🤝 Contributing

When contributing:

1. Follow the existing architecture patterns
2. Keep features isolated and self-contained
3. Write tests for new features
4. Update documentation as needed

## 📄 License

This project is licensed under the MIT License.

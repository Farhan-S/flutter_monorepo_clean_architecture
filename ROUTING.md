# App Routing Architecture

## Overview

The app uses a **centralized routing system** where all routes are defined in the `core` package and managed by `AppRouteGenerator` in the `app` package. This ensures consistent navigation across all feature modules.

## Architecture

```
packages/
├── core/                           # Shared infrastructure
│   └── src/routes/
│       └── app_routes.dart        # ✅ Route definitions & helpers
├── app/                            # Main application
│   └── routes/
│       └── app_route_generator.dart # ✅ Route generation & registration
└── features_*/                     # Feature modules
    └── presentation/
        └── pages/                  # ✅ Use AppRoutes for navigation
```

## Core Components

### 1. `AppRoutes` (in core package)

Centralized route definitions accessible by all modules:

```dart
// Route names
AppRoutes.home              // '/'
AppRoutes.networkTest       // '/network-test'
AppRoutes.login             // '/login'
AppRoutes.profile           // '/profile'
AppRoutes.settings          // '/settings'

// Navigation helpers
AppRoutes.navigateToHome(context)
AppRoutes.navigateToLogin(context)
AppRoutes.navigateToNetworkTest(context)
AppRoutes.navigateToProfile(context, userId: 'id')
AppRoutes.navigateBack(context)
```

### 2. `AppRouteRegistry`

Registry for modular route factories:

```dart
// Register routes
AppRouteRegistry.registerRoute('/custom-route', (settings) {
  return MaterialPageRoute(builder: (_) => CustomPage());
});

// Register multiple routes
AppRouteRegistry.registerRoutes({
  '/route1': (settings) => ...,
  '/route2': (settings) => ...,
});
```

### 3. `AppRouteGenerator` (in app package)

Handles route generation and BLoC injection:

```dart
MaterialApp(
  initialRoute: AppRoutes.home,
  onGenerateRoute: AppRouteGenerator.onGenerateRoute,
)
```

## Usage in Feature Modules

### ✅ Correct Usage

```dart
// In any feature page
import 'package:core/core.dart';

// Navigation
ElevatedButton(
  onPressed: () {
    AppRoutes.navigateToNetworkTest(context);
  },
  child: Text('Go to Network Test'),
)

// Or use direct navigation
Navigator.pushNamed(context, AppRoutes.networkTest);
```

### ❌ Avoid

```dart
// DON'T hardcode route strings
Navigator.pushNamed(context, '/network-test');  // ❌ Bad

// DON'T create custom routing in features
class FeatureRoutes { ... }  // ❌ Bad - use AppRoutes instead
```

## Adding New Routes

### Step 1: Define route in `core/src/routes/app_routes.dart`

```dart
class AppRoutes {
  // Add route name
  static const String myNewRoute = '/my-new-route';

  // Add navigation helper
  static Future<void> navigateToMyNewRoute(BuildContext context) {
    return Navigator.pushNamed(context, myNewRoute);
  }
}
```

### Step 2: Register route in `app/routes/app_route_generator.dart`

```dart
static void registerAllRoutes() {
  // ...existing routes...

  AppRouteRegistry.registerRoute(
    AppRoutes.myNewRoute,
    (settings) => MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<MyNewBloc>(),
        child: const MyNewPage(),
      ),
      settings: settings,
    ),
  );
}
```

### Step 3: Handle in fallback (optional)

```dart
static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Registry lookup happens first...

  // Fallback
  switch (settings.name) {
    // ...existing cases...
    case AppRoutes.myNewRoute:
      return _createRoute(MyNewPage(), settings);
  }
}
```

## Route Parameters

### Passing Parameters

```dart
// With arguments map
Navigator.pushNamed(
  context,
  AppRoutes.profile,
  arguments: {
    AppRoutes.userIdParam: 'user123',
    'customData': someData,
  },
);

// Using helper with parameters
AppRoutes.navigateToProfile(context, userId: 'user123');
```

### Receiving Parameters

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final userId = args?[AppRoutes.userIdParam] as String?;

    return Scaffold(
      body: Text('User ID: $userId'),
    );
  }
}
```

## Benefits

### ✅ Type Safety

- Route names are compile-time constants
- No typos in route strings

### ✅ Centralized

- All routes defined in one place
- Easy to see app navigation structure

### ✅ Modular

- Features use core routes
- No circular dependencies

### ✅ Testable

- Mock route navigation easily
- Test route generation separately

### ✅ Scalable

- Add new routes without modifying existing code
- Feature modules remain independent

## Current Routes

| Route        | Path            | BLoC Provider   | Description          |
| ------------ | --------------- | --------------- | -------------------- |
| Home         | `/`             | AuthBloc        | Main home page       |
| Network Test | `/network-test` | NetworkTestBloc | Network testing page |
| Login        | `/login`        | AuthBloc        | Login page           |

## Best Practices

1. **Always use `AppRoutes` constants** - Never hardcode route strings
2. **Use navigation helpers** - Cleaner code, less boilerplate
3. **Register routes in `registerAllRoutes()`** - Centralized registration
4. **Provide BLoCs at route level** - Proper lifecycle management
5. **Handle parameters consistently** - Use `AppRoutes` parameter constants
6. **Create error route** - Handle undefined routes gracefully

## Example: Complete Flow

```dart
// 1. Define in core
class AppRoutes {
  static const String productDetails = '/product/:id';

  static Future<void> navigateToProduct(
    BuildContext context,
    String productId,
  ) {
    return Navigator.pushNamed(
      context,
      productDetails,
      arguments: {'productId': productId},
    );
  }
}

// 2. Register in app
AppRouteRegistry.registerRoute(
  AppRoutes.productDetails,
  (settings) {
    final args = settings.arguments as Map?;
    final productId = args?['productId'] as String;

    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<ProductBloc>()
          ..add(LoadProduct(productId)),
        child: ProductDetailsPage(),
      ),
    );
  },
);

// 3. Use in feature
ElevatedButton(
  onPressed: () {
    AppRoutes.navigateToProduct(context, 'prod123');
  },
  child: Text('View Product'),
)
```

## Migration Guide

### From Old System

```dart
// Before
Navigator.pushNamed(context, '/network-test');

// After
AppRoutes.navigateToNetworkTest(context);
```

### From Direct Navigation

```dart
// Before
Navigator.push(context, MaterialPageRoute(
  builder: (_) => NetworkTestPage(),
));

// After
AppRoutes.navigateToNetworkTest(context);
```

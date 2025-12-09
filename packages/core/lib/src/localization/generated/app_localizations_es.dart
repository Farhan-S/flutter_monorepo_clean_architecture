// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aplicación de Arquitectura Limpia';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get enterEmail => 'Ingrese su correo electrónico';

  @override
  String get enterPassword => 'Ingrese su contraseña';

  @override
  String get forgotPassword => '¿Olvidó su contraseña?';

  @override
  String get dontHaveAccount => '¿No tiene una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get authenticated => 'Autenticado';

  @override
  String get notAuthenticated => 'No autenticado';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Saltar';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get onboardingTitle1 => 'Bienvenido a Arquitectura Limpia';

  @override
  String get onboardingDesc1 =>
      'Construya aplicaciones Flutter escalables y mantenibles con patrones de arquitectura adecuados y separación de preocupaciones.';

  @override
  String get onboardingTitle2 => 'Estructura de Paquetes Modular';

  @override
  String get onboardingDesc2 =>
      'Cada característica está aislada en su propio paquete con capas de dominio, datos y presentación usando Melos.';

  @override
  String get onboardingTitle3 => 'Gestión de Estado BLoC';

  @override
  String get onboardingDesc3 =>
      'Administre el estado de su aplicación de manera reactiva con el patrón BLoC, garantizando código predecible y comprobable.';

  @override
  String get onboardingTitle4 => 'Capa de Red Robusta';

  @override
  String get onboardingDesc4 =>
      'Manejo de errores integrado, lógica de reintento, actualización de tokens e interceptores para una comunicación API perfecta.';
}

import 'package:logger/logger.dart';

class LoggerUtil {
  static final Logger logger = Logger(
    level: Level.nothing,
    printer: PrettyPrinter(),
  );

  static void setLogLevel(Level level) {
    Logger.level = level;
  }
}

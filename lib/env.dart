import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _Env.appId;
  @EnviedField(varName: 'SERVER_URL', obfuscate: true)
  static final String serverUrl = _Env.serverUrl;
  @EnviedField(varName: 'CLIENT_KEY', obfuscate: true)
  static final String clientKey = _Env.clientKey;
  @EnviedField(varName: 'MASTER_KEY', obfuscate: true)
  static final String masterKey = _Env.masterKey;
}

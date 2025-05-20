import 'package:logging/logging.dart';
import 'package:tiny_satoshi/services/keychain.dart';

final _log = Logger("CredentialsManager");

class CredentialsManager {
  static const String accountMnemonic = "account_mnemonic";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeMnemonic({required String mnemonic}) async {
    try {
      await _storeMnemonic(mnemonic);
      _log.info("Stored credentials successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String?> restoreMnemonic() async {
    String? mnemonicStr = await keyChain.read(accountMnemonic);
    _log.info("Restored credentials successfully");
    return mnemonicStr;
  }

  // Helper methods
  Future<void> _storeMnemonic(String mnemonic) async {
    await keyChain.write(accountMnemonic, mnemonic);
  }
}

import 'dart:async';

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

import 'credentials_manager.dart';
import 'wallet_state.dart';

final _log = Logger("WalletCubit");

class WalletCubit extends Cubit<WalletState> with HydratedMixin {
  final CredentialsManager _credentialsManager;

  late Wallet _wallet;
  late Blockchain _blockchain;

  WalletCubit(this._credentialsManager) : super(WalletState.initial()) {
    hydrate();
  }

  Future connect({required String mnemonic}) async {
    _log.info('Connection to bdk with mnemonic: $mnemonic');
    try {
      await _credentialsManager.storeMnemonic(mnemonic: mnemonic);

      // final storedMnemonic = await _credentialsManager.restoreMnemonic();
      final descriptors = await _createDescriptors(mnemonic);

      _blockchain = await Blockchain.create(
        config: const BlockchainConfig.electrum(
          config: ElectrumConfig(
            stopGap: 10,
            timeout: 5,
            retry: 5,
            // url: "ssl://electrum.blockstream.info:60002",
            url: "ssl://testnet.aranguren.org:51002",
            validateDomain: false,
          ),
        ),
      );

      _wallet = await Wallet.create(
        descriptor: descriptors[0],
        changeDescriptor: descriptors[1],
        // network: state.network,
        network: Network.Testnet,
        databaseConfig: const DatabaseConfig.memory(),
      );

      _log.info("bdk connected successfully");
    } catch (e) {
      _log.warning("failed to connect to bdk lib", e);
      rethrow;
    }
  }

  Future<List<Descriptor>> _createDescriptors(String mnemonic) async {
    _log.info('Creating descriptors...');

    final descriptors = <Descriptor>[];
    for (var e in [KeychainKind.External, KeychainKind.Internal]) {
      final mnemonicObj = await Mnemonic.fromString(mnemonic);
      final descriptorSecretKey = await DescriptorSecretKey.create(
        network: Network.Testnet,
        mnemonic: mnemonicObj,
      );
      final descriptor = await Descriptor.newBip84(
        secretKey: descriptorSecretKey,
        network: Network.Testnet,
        keychain: e,
      );
      descriptors.add(descriptor);
    }
    _log.info('Descriptors created successfully');
    return descriptors;
  }

  Future<void> sync() async {
    _log.info('Syncing wallet...');
    await _wallet.sync(_blockchain);
  }

  Future<List<String>?> getMnemonic() async {
    _log.info('Getting mnemonic...');
    final mnemonic = await _credentialsManager.restoreMnemonic();
    _log.info('Mnemonic: $mnemonic');
    return mnemonic?.split(' ');
  }

  Future<String> getReceiveAddress() async {
    _log.info('Getting receive address...');
    final address = await _wallet.getAddress(addressIndex: AddressIndex());
    _log.info('Receive address: $address');
    return address.address;
  }

  Future<void> getBalance() async {
    _log.info('Getting balance...');
    final balance = await _wallet.getBalance();
    emit(state.copyWith(balance: balance.total / 100000000));
  }

  Future<void> sendBitcoin({
    required String addressStr,
    required double amount,
    required double fee,
  }) async {
    _log.info('Sending bitcoin to $addressStr with amount $amount');
    try {
      emit(state.copyWith(isTransferring: true));
      await Future.delayed(Duration(seconds: 10));
      // final amountInSats = btcToSats(amount);
      // final txBuilder = TxBuilder();
      // final address = await Address.create(address: addressStr);
      // final script = await address.scriptPubKey();
      // final txBuilderResult = await txBuilder
      //     .addRecipient(script, amountInSats)
      //     .feeRate(fee)
      //     .finish(_wallet);
      // final sbt = await _wallet.sign(psbt: txBuilderResult.psbt);
      // final tx = await sbt.extractTx();
      // await _blockchain.broadcast(tx);
    } finally {
      emit(state.copyWith(isTransferring: false));
    }
  }

  int btcToSats(double btc) {
    final amountInSats = (btc * 100000000).round();
    return amountInSats;
  }

  @override
  WalletState? fromJson(Map<String, dynamic> json) {
    return WalletState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(WalletState state) {
    return state.toJson();
  }

  @override
  String get storagePrefix => "WalletCubit";
}

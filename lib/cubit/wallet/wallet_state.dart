import 'dart:convert';

import 'package:bdk_flutter/bdk_flutter.dart';

class WalletState {
  final double balance;
  final bool isTransferring;
  final Network network;

  const WalletState({
    required this.network,
    required this.balance,
    this.isTransferring = false,
  });

  factory WalletState.initial() {
    return const WalletState(network: Network.Testnet, balance: 0.0);
  }

  WalletState copyWith({
    double? balance,
    bool? isTransferring,
    Network? network,
  }) {
    return WalletState(
      network: network ?? this.network,
      balance: balance ?? this.balance,
      isTransferring: isTransferring ?? this.isTransferring,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'network': network.name,
      'balance': balance,
      'isTransferring': isTransferring,
    };
  }

  factory WalletState.fromJson(Map<String, dynamic> json) {
    return WalletState(
      network:
          json['network'] != null
              ? Network.values.byName(json['network'])
              : Network.Testnet,
      balance: json['balance'] as double,
      isTransferring: json['isTransferring'] as bool? ?? false,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}

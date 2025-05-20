import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState()) {
    debugPrint('[+] GameCubit initialized with state: ${state.hasKey}');
  }

  void setHasKey(bool hasKey) {
    debugPrint('[+] GameCubit => setHasKey: $hasKey');
    debugPrint('[+] GameCubit => previous state: ${state.hasKey}');
    emit(state.copyWith(hasKey: hasKey));
    debugPrint('[+] GameCubit => new state: ${state.hasKey}');
  }

  void setGoblinDialogShown(bool shown) =>
      emit(state.copyWith(hasGoblinShownDialog: shown));

  void setImpDialogShown(bool shown) =>
      emit(state.copyWith(hasImpShownDialog: shown));

  void setMiniBossDialogShown(bool shown) =>
      emit(state.copyWith(hasMiniBossShownDialog: shown));

  void reset() => emit(const GameState());
}

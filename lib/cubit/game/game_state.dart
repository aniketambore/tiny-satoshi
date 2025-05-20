class GameState {
  final bool hasKey;
  final bool hasGoblinShownDialog;
  final bool hasImpShownDialog;
  final bool hasMiniBossShownDialog;

  const GameState({
    this.hasKey = false,
    this.hasGoblinShownDialog = false,
    this.hasImpShownDialog = false,
    this.hasMiniBossShownDialog = false,
  });

  GameState copyWith({
    bool? hasKey,
    bool? hasGoblinShownDialog,
    bool? hasImpShownDialog,
    bool? hasMiniBossShownDialog,
  }) {
    return GameState(
      hasKey: hasKey ?? this.hasKey,
      hasGoblinShownDialog: hasGoblinShownDialog ?? this.hasGoblinShownDialog,
      hasImpShownDialog: hasImpShownDialog ?? this.hasImpShownDialog,
      hasMiniBossShownDialog:
          hasMiniBossShownDialog ?? this.hasMiniBossShownDialog,
    );
  }
}

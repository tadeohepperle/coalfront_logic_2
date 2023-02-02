/// things like turn transitions. Only relevant on the client side.
/// Client receives GameEvents, emits UiEvents towards UI;
/// These are more fine-grained than the raw GameEvents.
/// UiEvents are emitted in two cases:
/// - as immediate feedback to PlayerInputAction on client side
/// - as a response to a GameEvent received from the server
/// Often a combination of the two is triggered by each PlayerInputAction.
/// One GameEvent received, can also trigger multiple UiEvents in sequence.
/// The stream of UiEvents is read by the Ui sequentially to give sequential Animations
/// (e.g. an incoming element is processed, only if its animation is done executing the next is processed.)

/// dart3 sealed
abstract class UiEvent {}

class UiLoadingGame extends UiEvent {}

class UiLoadedGame extends UiEvent {}

class UiPlayerJoined extends UiEvent {}

class UiBeginGame extends UiEvent {}

class UiOthersDraftPickDone extends UiEvent {}

class UiNextDraftRoundStarted extends UiEvent {}

class UIPlayPhaseStarted extends UiEvent {}

class UISelfPassedTurn extends UiEvent {}

class UISelfEndedTurn extends UiEvent {}

class UiPlayerPassedTurn extends UiEvent {}

class UiPlayerEndedTurn extends UiEvent {}

class UiPlayPhaseUpdate extends UiEvent {}

class UiEndPhaseStarted extends UiEvent {}

class UiSelfBuiltBuilding extends UiEvent {}

class UiMapUpdate extends UiEvent {}

class UiPlayerBuiltBuilding extends UiEvent {}

class UiPlayerMadePlayInvisible extends UiEvent {}

class UiSelfLeft extends UiEvent {}

class UiPlayerLeft extends UiEvent {}

class UiSelfEndedGame extends UiEvent {}

class UiGameWasEnded extends UiEvent {}

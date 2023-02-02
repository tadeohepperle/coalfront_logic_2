/// reflect what the player is doing in the UI.
/// are translated into PlayerActions and sent to the server
abstract class PlayerInputAction {}

class PlayerInputJoinGame extends PlayerInputAction {}

class PlayerInputLeaveGame extends PlayerInputAction {}

class PlayerInputEndGame extends PlayerInputAction {}

class PlayerInputDraftPick extends PlayerInputAction {}

class PlayerInputPassTurn extends PlayerInputAction {}

class PlayerInputEndTurn extends PlayerInputAction {}

class PlayerInputBuildBuilding extends PlayerInputAction {}

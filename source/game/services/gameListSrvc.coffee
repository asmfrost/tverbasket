angular.module("gameServices").factory "gameListSrvc", [
  "$resource"
  ($resource) ->
    return $resource("assets/games.json")
]
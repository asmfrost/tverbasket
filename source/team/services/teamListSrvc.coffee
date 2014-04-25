# Служба получения перечня команд
angular.module("teamServices").factory "teamListSrvc", [
  "$resource"
  ($resource) ->
    return $resource("assets/teams/teams.json")
]
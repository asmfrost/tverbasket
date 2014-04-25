# Контроллер получения списка игр
angular.module("gameControllers").controller "gameListCtrl", [
  "$scope"
  "games"
  "teams"
  "$templateCache"
  ($scope, games, teams, $templateCache) ->
    $templateCache.removeAll()
    $scope.games = games
    $scope.teams = teams
    i = 0

    # Привязваем к играм изображения и названия команд
    # для отображения названий и изображений из одного массива объектов (games)
    while i < $scope.games.length
      j = 0

      while j < $scope.teams.length
        if $scope.games[i].team_1_id is $scope.teams[j].id
          $scope.games[i].team_1_name = $scope.teams[j].team_name
          $scope.games[i].team_1_img = $scope.teams[j].img[0]
        if $scope.games[i].team_2_id is $scope.teams[j].id
          $scope.games[i].team_2_name = $scope.teams[j].team_name
          $scope.games[i].team_2_img = $scope.teams[j].img[0]
        j++
      i++
]
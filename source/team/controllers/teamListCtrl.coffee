# Создает массив объектов команд в области видимости
angular.module("teamControllers").controller "teamListCtrl", [
  "$scope"
  "teams"
  ($scope, teams) ->
    $scope.teams = teams
]
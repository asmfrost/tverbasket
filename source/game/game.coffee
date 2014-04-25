# Модуль games
angular.module("game", [
  "ngResource"
  "gameControllers"
  "gameServices"
]).config ($routeProvider) ->
  $routeProvider.when "/game",   # отобразить игры
    controller: "gameListCtrl"   # данным контроллером
    resolve:
      games: (gameListSrvc) ->   # загрузив их список
        gameListSrvc.query()

      teams: (teamListSrvc) ->   # и перечень команд
        teamListSrvc.query()

    templateUrl: "game/views/gameListView.html" # в данном шаблоне

  return

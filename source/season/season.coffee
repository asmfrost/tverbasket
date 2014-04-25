# Модуль season - отображает игры в сезоне лиги
angular.module("season", [
  "ngResource"
  "seasonControllers"
]).config ($routeProvider) ->
  $routeProvider.when "/season",        # при открытии страницы сезона
    controller: "seasonViewCtrl"
    resolve:
      games: (gameListSrvc) ->          # получаем список прошедших игр
        gameListSrvc.query()

      teams: (teamListSrvc) ->          # и команд
        teamListSrvc.query()

    templateUrl: "season/views/seasonViewView.html"   # и отображаем в данном шаблоне

  return

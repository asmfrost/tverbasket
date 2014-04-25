# Модуль team - отображает команды лиги из json файла через службу
angular.module("team", [
  "ngRoute"
  "ngResource"
  "teamControllers"
  "teamServices"
]).config ($routeProvider) ->
  $routeProvider.when "/team",   # если открыта страница команд
    controller: "teamListCtrl"   # используем контроллер списка команд
    resolve:
      teams: (teamListSrvc) ->   # предварительно получил сам список при помощи службы
        teamListSrvc.query()

    templateUrl: "team/views/teamListView.html" # и для визуализации использовать данный шаблон

  return

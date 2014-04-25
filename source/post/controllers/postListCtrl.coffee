# Контроллер загрузки и отображения списка новостей
angular.module("postControllers").controller "postListCtrl", [
  "$scope"
  "posts"
  ($scope, posts) ->
    $scope.postsList = posts
    $scope.year = 2014
    $scope.setYear = (year) -> # фильтрует новости по году
      $scope.year = year
      return
]
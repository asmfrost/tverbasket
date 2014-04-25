# модуль отображения новости
angular.module("postControllers").controller "postViewCtrl", [
  "$scope"
  "$location"
  "post"
  ($scope, $location, post) ->
    $scope.post = post
]
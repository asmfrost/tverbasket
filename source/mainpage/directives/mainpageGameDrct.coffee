angular.module("mainpageDirectives").directive "gamesList", [
  "gameListCtrl"
  (gameListCtrl) ->
    return (
      restrict: "A"
      replace: true
      templateUrl: "games/views/gameListView.html"
    )
]
angular.module("mainpage", [
  "ngRoute"
  "mainpageDirectives"
]).config ($routeProvider) ->
  $routeProvider.when "/",
    templateUrl: "mainpage/views/mainpageView.html"
    resolve:
      posts: (postListSrvc) ->
        postListSrvc()

      games: (gameListSrvc) ->
        gameListSrvc.query()

      teams: (teamListSrvc) ->
        teamListSrvc.query()

    controller: "mainpageMainCtrl"

  return

# Контроллер новостей
angular.module("post", [
  "ngRoute"
  "ngSanitize"
  "postServices"
  "postDirectives"
  "postControllers"
  "postFilters"
]).config ($routeProvider) ->
  $routeProvider.when("/post",        # отображаем список новостей
    controller: "postListCtrl"        # с помощью данного контроллера
    resolve:
      posts: (postListSrvc) ->        # получив список с помощью службы
        postListSrvc()

    templateUrl: "post/views/postListView.html" # в данном шаблоне
  ).when("/post/:postId",            # отображаем конкретную новость
    controller: "postViewCtrl"
    resolve:
      post: (postLoadSrvc) ->        # выбрав ее по :postId
        postLoadSrvc()

    templateUrl: "post/views/postDetailView.html" # в данном шаблоне
  )

  return

# Служба загрузки одной новости по :postId
angular.module("postServices").factory "postDetailSrvc", [
  "$resource"
  "$route"
  ($resource, $route) ->
    return $resource("assets/posts/:postId.json", # возвращает json файл по :postId в имени файла
      postId: "posts"
    ,
      query:
        method: "get"
        param:
          postId: $route.current.params.postId

        isArray: true
    )
]
# служба загрузки новости по :postId
angular.module("postServices").factory "postLoadSrvc", [
  "postDetailSrvc"
  "$route"
  "$q"
  # на основе :postId новости возвращает ее через обещание
  (postDetailSrvc, $route, $q) ->
    return ->
      delay = $q.defer()  # инициализация обещания
      postDetailSrvc.get  # методом get через службу выборки по :postId
        postId: $route.current.params.postId  # по :postId из пути
      , ((post) ->
        delay.resolve post     # возвращаем новости в случае успеха
        return
      ), ->
        # или выводим сообщение об ошибке
        delay.reject "Невозможно загрузить новость: " + $route.current.params.postId
        return

      delay.promise # возвращаем обещание
]
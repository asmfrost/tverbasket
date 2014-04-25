# получение списка всех новостей
angular.module("postServices").factory "postListSrvc", [
  "postDetailSrvc"
  "$q"
  (postDetailSrvc, $q) ->
    return ->
      delay = $q.defer()  # создаем обещание
      postDetailSrvc.query ((posts) ->  # делаем выборку всех новостей
        delay.resolve posts      # в случае успеха возвращаем список
        return
      ), ->
        delay.reject "Невозможно загрузить новости" # или выдаем сообщение об ошибке
        return

      delay.promise  # возвращаем обещание
]
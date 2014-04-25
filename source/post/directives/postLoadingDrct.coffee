angular.module("postDirectives").directive "postLoadingDrct", [
  "$rootScope"
  ($rootScope) ->
    return link: (scope, element, attrs) ->
      element.addClass "post-hide"
      $rootScope.$on "$routeChangeStart", ->
        element.removeClass "post-hide"
        return

      $rootScope.$on "$routeChangeSuccess", ->
        element.addClass "post-hide"
        return

      return
]
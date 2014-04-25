angular.module("postDirectives").directive "postFocusDrct", ->
  link: (scope, element, attrs) ->
    element[0].focus()
    return

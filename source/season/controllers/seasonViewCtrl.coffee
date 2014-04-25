# Формирует и отображает таблицу результатов и турнирную таблицу сезона
angular.module("seasonControllers").controller "seasonViewCtrl", [
  "games"
  "teams"
  "$templateCache"
  (games, teams, $templateCache) ->
    # Очищаем кэш страницы для подгрузки названий команд из объекта teams
    # чтобы вместо них при возвращении на страницу не кэшировались id из games
    $templateCache.removeAll()

    i = 0

    teamsResults = [] # массив объектов для хранения результатов команд в сезоне

    gamesCount = 0    # вспомогательные переменные для подсчета результатов
    winsCount = 0     #

    # Вычисляем результаты выступлений команд в сезоне
    while i < teams.length
      j = 0

      # Для i-ой команды проверяем участие в играх сезона
      while j < games.length
        # увеличиваем общее количество проведенных игры
        gamesCount++  if teams[i].id is games[j].team_1_id or teams[i].id is games[j].team_2_id
        # и количество выйгранных игр
        winsCount++  if teams[i].id is games[j].winner_id
        j++ # следующая игра

      # Добавляем в массив команд ее название и результаты в текущем сезоне
      teamsResults[i] = {}
      teamsResults[i].team_name = teams[i].team_name
      teamsResults[i].gamesCount = gamesCount
      teamsResults[i].winsCount = winsCount

      #Обнуляем счетчики для сохранения результатов следующей команды
      gamesCount = 0
      winsCount = 0

      i++ # следующая команда

    i = 0

    # формируем строку с разметкой и данными о результатах выступления команд в сезоне
    str = "<table><tr>" + "<th>Место</th>" + "<th>Команда</th>" + "<th>Всего очков</th>" + "<th>Выиграно игр</th>" + "<th>Всего игр</th></tr>"

    # сортируем команды по количеству набранных очков
    # если количество очков одинакого, сортируем спорные команды по количеству побед
    teamsResults = teamsResults.sort((a, b) ->
      (if (a.winsCount + a.gamesCount) is (b.winsCount + b.gamesCount) then ((if (a.winsCount) > (b.winsCount) then -1 else 1)) else ((if (a.winsCount + a.gamesCount) > (b.winsCount + b.gamesCount) then -1 else 1)))
    )

    # формируем строки таблицы с результатами команд
    while i < teamsResults.length
      str += "<tr><td>" + (i + 1) + "</td>" + "<td>" + teamsResults[i].team_name + "</td>" + "<td>" + (teamsResults[i].winsCount + teamsResults[i].gamesCount) + "</td>" + "<td>" + teamsResults[i].winsCount + "</td>" + "<td>" + teamsResults[i].gamesCount + "</td></tr>"
      i++

    # закрываем таблицу
    str += "</table>"
    # и выводи результат
    jQuery("#seasonResults").append str


    # формируем таблицу игры в сезоне
    str = "<table><tr><th>Сезон 2013-2014</th>"

    i = 0

    # формируем верхнюю строку с командами и их логотипами
    while i < teams.length
      str += "<th>" + "<img src=\"" + teams[i].img[0] + "\"/>" + "<em><br/>" + teams[i].team_name + "</em>" + "</th>"
      i++
    str += "</tr>"

    found = false  # индикатор отсутсвия игры между командами, если false - выводим отсутствие игры

    i = 0

    # формируем результаты игр
    # путем перебора команд
    while i < teams.length
      # первый столбец в строке будет названием команды
      str += "<tr><td>" + teams[i].team_name + "</td>"
      j = 0
      # осуществляем перебор игр между командами
      while j < teams.length
        # если это одна и таже команда
        if teams[i].id is teams[j].id
          # выводим заглушку
          str += "<td><img src=\"assets/tverbasket/firelogo.png\"/></td>"
        else
          k = 0 # обнуляем счетчик игр

          # и путем обхода всех игр
          while k < games.length
            # если игра между командами найдена
            if games[k].team_1_id is teams[i].id and games[k].team_2_id is teams[j].id
              # формируем ее результат
              str += "<td>" + games[k].team_1_score + " : " + games[k].team_2_score + "</td>"
              found = true # игра найдена
            k++
          # иначе формируем заглушку
          str += "<td> - </td>"  unless found
        # сбрасываем индикатор для следующей игры
        found = false
        j++ # следующая команда
      str += "</tr>" # следующая команда
      i++
    str += "</table>"

    # выводим сформированную турнирную таблицу
    jQuery("#seasonTable").append str
]
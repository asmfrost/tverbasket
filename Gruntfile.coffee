# Подключаем модуль path для сборки путей проекта
path = require 'path'

# Конфигурация сборки проекта
module.exports = (grunt) ->
  # Загружаем все задачи сборки автоматически с помощью данного модуля
  require('load-grunt-tasks')(grunt)
  # и включаем отслеживание хода сборки пректа
  require('time-grunt')(grunt)

  # Описываем операции по сборке проекта и назначаем задачи сборки
  grunt.initConfig
  # Будем использовать настройки проекта по ходу сборки для вставки путей
    settings:
    # Структурируем директории проекта
      destDirectory: 'release'
      srcDirectory: 'source'
      tempDirectory: 'build'

  # Установка необходимых библиотек через Bower,
  # размещение их во временной папке .temp/bower_components,
  # из которой затем нужные нам файлы библиотек (js и map, см. bower.json, .bowerrc)
  # перемещаются в папку bower_components/scripts
    bower:
      install:
        options:
          cleanTargetDir: true
          copy: true
          layout: (type, component) -> # Тут формируется структура директорий
            path.join type
          targetDir: 'vendors'
      uninstall:
        options:
          cleanBowerDir: true
          cleanTargetDir: true
          targetDir: 'vendors'
          copy: false
          install: false

  # Удаление необходимых папок перед сборкой
    clean:
    # Удаляет папку временного хранения файлов времени сборки проекта
    # и папку, где будет размещаться готовый проект
      working: [
        '<%= settings.tempDirectory %>',
        '<%= settings.destDirectory %>'
      ]

  # Настройка результатов компиляции скриптов coffee-script
    coffee:
    # Для того, чтобы не засорять исходные файлы проекта,
    # мы компилируем их во временной папке с сохранением структуры
    # директорий проекта (см. copy:)
      app:
        files: [
          cwd: '<%= settings.tempDirectory %>'
          src: '**/*.coffee'
          dest: '<%= settings.tempDirectory %>'
          expand: true
          ext: '.js'
        ]
        options:
          sourceMap: true

  # Проверка корректности написания кода для компиляции coffee-script
    coffeelint:
      app:
      # Проверяем все исходные файлы, за исключением кода библиотек
        files: [
          cwd: ''
          src: [
            'source/**/*.coffee',
            '!vendors/scripts/libs/**'
          ]
        ]
        options:
          indentation:
            value: 2
          max_line_length:
            level: 'ignore'
          no_tabs:
            level: 'ignore'

  # Копирование проверенных (coffeelint) исходных файлов во временную директорию
  # для последующей компиляции
    copy:
    # Из исходников
      app:
        files: [
          # Исходные файлы проекта с сохранением структуры директорий
          cwd: '<%= settings.srcDirectory %>'
          src: '**'
          dest: '<%= settings.tempDirectory %>'
          expand: true
        ,
          # Файлы библиотек с сохранением структуры директорий
          cwd: 'vendors'
          src: [
            '**',
            '!*untyped__/**.*',
            '!*untyped__'
            ]
          dest: '<%= settings.tempDirectory %>\\vendors'
          expand: true
        ]
    # После компиляции в версию для отладки
      dev:
      # Исходные файлы проекта с сохранением структуры директорий
        cwd: '<%= settings.tempDirectory %>'
        src: '**'
        dest: '<%= settings.destDirectory %>'
        expand: true
    # Версия для релиза
      release:
        files: [
          cwd: '<%= settings.tempDirectory %>'
          src: [
            'js/app.min.js'
            'js/shiv.json.min.js'
            'vendors/'
            'assets/**/*.*'
            'index.html'
            'css/styles.min.css'
          ]
          dest: '<%= settings.destDirectory %>'
          expand: true
        ]
      html:
        files: [
          cwd: '<%= settings.tempDirectory %>'
          src: [
            '**/*.html'
            '!build/index.html'
          ]
          ext: '.html'
          dest: '<%= settings.destDirectory %>'
          expand: true
        ]

  # Компилирование less в css
    less:
      app:
        src: '<%= settings.tempDirectory %>/**/*.less'
        ext: '.css'
        expand: true

  # Обработка html шаблонов для выбора нужного варианта подключения скриптов
    template:
      indexDev:
        files:
          'build/index.html': 'build/index.html'
      release:
        files: '<%= template.indexDev.files %>'
        environment: 'release'

  # Уменьшает размер подключаемых для совместимости с ie скриптов
    uglify:
      options:
        mangle: false
        preserveComments: false
      iecapab:
        files:
          '<%= settings.tempDirectory %>/js/shiv.json.min.js' : [
            '<%= settings.tempDirectory %>/vendors/json3/json3.min.js'
            '<%= settings.tempDirectory %>/vendors/html5shiv/html5shiv-printshiv.min.js'
          ]
      app:
        files:
          '<%= settings.tempDirectory %>/js/app.min.js' : '<%= settings.tempDirectory %>/js/app.min.js'


  # Слияние файлов
    concat:
      options:
        stripBanners: true
        expand: true
      css:
        src: [
          '<%= settings.tempDirectory %>/**/*.css'
          '!<%= settings.tempDirectory %>/css/styles.css'
        ]
        dest: '<%= settings.tempDirectory %>/css/styles.css'
      js:
        src: [
          '<%= settings.tempDirectory %>/post/post.js',
          '<%= settings.tempDirectory %>/post/services/postServices.js',
          '<%= settings.tempDirectory %>/post/services/postDetailSrvc.js',
          '<%= settings.tempDirectory %>/post/services/postListSrvc.js',
          '<%= settings.tempDirectory %>/post/services/postLoadSrvc.js',
          '<%= settings.tempDirectory %>/post/directives/postDirectives.js',
          '<%= settings.tempDirectory %>/post/directives/postLoadingDrct.js',
          '<%= settings.tempDirectory %>/post/directives/postFocusDrct.js',
          '<%= settings.tempDirectory %>/post/filters/postFilters.js',
          '<%= settings.tempDirectory %>/post/filters/postYearFltr.js',
          '<%= settings.tempDirectory %>/post/controllers/postControllers.js',
          '<%= settings.tempDirectory %>/post/controllers/postListCtrl.js',
          '<%= settings.tempDirectory %>/post/controllers/postEditCtrl.js',
          '<%= settings.tempDirectory %>/post/controllers/postViewCtrl.js',
          '<%= settings.tempDirectory %>/post/controllers/postCreateCtrl.js',
          '<%= settings.tempDirectory %>/post/controllers/postInfoCtrl.js',

          '<%= settings.tempDirectory %>/team/team.js',
          '<%= settings.tempDirectory %>/team/services/teamServices.js',
          '<%= settings.tempDirectory %>/team/services/teamListSrvc.js',
          '<%= settings.tempDirectory %>/team/controllers/teamControllers.js',
          '<%= settings.tempDirectory %>/team/controllers/teamListCtrl.js',

          '<%= settings.tempDirectory %>/game/game.js',
          '<%= settings.tempDirectory %>/game/services/gameServices.js',
          '<%= settings.tempDirectory %>/game/services/gameListSrvc.js',
          '<%= settings.tempDirectory %>/game/controllers/gameControllers.js',
          '<%= settings.tempDirectory %>/game/controllers/gameListCtrl.js',
          '<%= settings.tempDirectory %>/game/game.js',


          '<%= settings.tempDirectory %>/season/season.js',
          '<%= settings.tempDirectory %>/season/controllers/seasonControllers.js',
          '<%= settings.tempDirectory %>/season/controllers/seasonViewCtrl.js',

          '<%= settings.tempDirectory %>/mainpage/directives/mainpageDirectives.js',
          '<%= settings.tempDirectory %>/mainpage/directives/mainpageGameDrct.js',
          '<%= settings.tempDirectory %>/mainpage/mainpage.js',
          '<%= settings.tempDirectory %>/mainpage/directives/mainpageDirectives.js',
          '<%= settings.tempDirectory %>/mainpage/controllers/mainpageMainCtrl.js',

          '<%= settings.tempDirectory %>/tverbasket.js',
          '!<%= settings.tempDirectory %>/vendors/**/*.*'
        ]
        dest: '<%= settings.tempDirectory %>/js/app.js'
      libs:
        src: [
          '<%= settings.tempDirectory %>/vendors/jquery/index.js'
          '<%= settings.tempDirectory %>/vendors/angular/angular.min.js'
          '<%= settings.tempDirectory %>/vendors/angular-locale/angular-locale_ru-ru.js'
          '<%= settings.tempDirectory %>/vendors/angular-route/angular-route.min.js'
          '<%= settings.tempDirectory %>/vendors/angular-sanitize/angular-sanitize.min.js'
          '<%= settings.tempDirectory %>/vendors/angular-resource/angular-resource.min.js'
          '<%= settings.tempDirectory %>/js/app.js'
        ]
        dest: '<%= settings.tempDirectory %>/js/app.min.js'


  # Уменьшает размер css файлов
    cssmin:
      options:
        keepSpecialComments: 0
      minify:
        src: '<%= settings.tempDirectory %>/css/styles.css'
        dest: '<%= settings.tempDirectory %>/css/styles.min.css'

  # Уменьшает размер html файла
    minifyHtml:
      prod:
        src: [
          'build/index.html'
          '<%= settings.tempDirectory %>/**/*.html'
        ]
        ext: '.html'
        expand: true

  # версия для отладки
  grunt.registerTask 'build', [
    'clean:working'
    'coffeelint'
    'copy:app'
    'coffee:app'
    'less'
    'template:indexDev'
    'copy:dev'
  ]

  grunt.registerTask 'default', [
    'build'
  ]

  # версия для развертывания со всеми минификациями
  grunt.registerTask 'release', [
    'clean:working'
    'coffeelint'
    'copy:app'
    'coffee:app'
    'less'
    'concat:css'
    'concat:js'
    'concat:libs'
    'uglify:app'
    'uglify:iecapab'
    'template:release'
    'minifyHtml'
    'cssmin'
    'copy:release'
    'copy:html'
  ]

Что это такое?
=============

Vvsh - это cgi-библиотека для bash

Должен ли я использовать это?
=============

До тех пор, пока ваш проект не велик, вроде домашней странички или веб-морды к каким-нибудь скриптам, используйте спокойно. 

В остальных случаях забудьте о vvsh, он не подходит для больших проектов.

Какие системные требования?
=============

Нужен относительно последний bash (с поддержкой хэш-массивов). Если вы хотите отправлять запросы с файлами (multipart form-data), то вам понадобится либо Python, либо желание переписать py-модуль на другом языке.

Где документация?
=============

Вы смотрите на краткий вводный курс.

###Исполняемые файлы

Исполяемые файлы находятся в $APPS и имеют расширение .wsh. Именно на их выполнение следует настраивать веб-сервер.
Файлы "библиотек" находятся в $LIBS/$APP. Переменная APP устанавливается функцией app (из utils.sh), остальные - в config.sh


Wsh-файлы являются обычными html-страницами, за исключением одной особенности: всё, что находится между <% и %> считается bash-кодом и выполняется.
Этот код имеет поддержку макросов (пока только один :)) и при препроцессинге не трогается. Остальные же части документа обрамляются в echo -ne "" и кавычки в них экранируются.

###Переменные окружения

Во-первых, из vvsh доступны все обычные для cgi-скриптов переменные вроде $REMOTE\_ADDR, $REQUEST_METHOD или $QUERY\_STRING.
Во-вторых, http-GET и POST-параметры загоняются в массив http\_params. Например, ${http\_params[act]} вернет вам переменную act из запроса.


Когда идет работа с загружаемыми файлами, задействуется еще один массив: http\_files.
В него помещаются пути ко временным файлам, в то время как в соответствующее значение в http\_params помещается имя файла на компьютере клиента. Осторожней с этими значениями, всегда используйте basename и регекспы для проверки их на безопасность.


Также следует осторожно помещать выражения в параметры команд вроде grep или sed без использования специальных опций. Это вам не php, перед выполнением каждой команды переменные раскрываются.

###Стандартные функции

Перечень всех функций стандартной библиотеки:

* die - завершает выполнение скрипта. Используйте вместо exit, чтобы после vvsh не оставалось временных файлов.
* print $string - функция для пафоса, алиас для echo -ne.
* require $file - выполняет другой wsh-сценарий относительно DOCUMENT_ROOT. Желательно использовать $APPS/ для единственного аргумента-файла. 
* app $new - устанавливает переменную $APP
* import $module - загружает sh-библиотеку из $LIBS/$APP
* header $type - отправляет http-заголовок и cookies, если они есть
* redirect $url - отправляет http-заголовок с редиректом на $url и отправляет cookies, если они есть
* add_cookie $name $value - создает cookie с именем $name и значением $value
* debug $mark $text - отправляет в лог веб-сервера $text, помеченный "[DEBUG::$mark]"

###Некоторые замечания

Относитесь внимательно к кавычкам. К примеру, если мы вызываем функцию func так:

    func $param
  
То если в param содержится "hello world", то после раскрытия переменных будет выглядеть так:

    func hello world
  
И в результате в функцию будет передан не один параметр, а два. Для веб-приложений это очень опасно. Вызывайте функции так:

    func "$param"
  
Если вам нужно провернуть очень сложный финт со скобками, можно сделать так:

    func {"$param1","$param2"} #первым параметром будет $param1, а вторым - $param2

Объявление хэш-массива:

    declare -A param #должно быть вне функций

Пример прохода по хэш-массиву:

    for name in ${!param[@]}; do
      value="${param[$name]}"
      ...
    done
  
В wsh-сценариях для краткости это можно заменить макросом:

    <% for name, value in param; do %>
      <a href="<% print $value %>">$name</a>
    <% done %>
 
Контакты
======

Если у вас есть предложения или вам нужна помощь в осваивании vvsh, я всегда готов помочь по Jabber: derlafff@qip.ru
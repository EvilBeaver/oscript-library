# Библиотека полезных скриптов для 1Script

[![Join the chat at https://gitter.im/EvilBeaver/oscript-library](https://badges.gitter.im/EvilBeaver/oscript-library.svg)](https://gitter.im/EvilBeaver/oscript-library?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

<a href="https://zenhub.io"><img src="https://raw.githubusercontent.com/ZenHubIO/support/master/zenhub-badge.png"></a>

Все пакеты библиотеки могут быть подключены с помощью директивы **#Использовать <ИмяПакета>**

## Краткий список и назначение пакетов

###[asserts](https://github.com/oscript-library/asserts)

Добавляет в скрипт функционал "Утверждений" (assertions). Возможны 2 стиля использования:

* Модуль "Утверждения" - утверждения в стиле фреймворка xUnitFor1C
* Свойство глобального контекста "Ожидаем" - fluent-API утверждений в стиле BDD

###[cmdline](https://github.com/oscript-library/cmdline)

Библиотека разбора аргументов командной строки. Добавляет класс "ПарсерАргументовКоманднойСтроки", позволяющий удобным образом обрабатывать параметры запуска скрипта.

###[files-common](https://github.com/oscript-library/files-common)

Часто используемые функции для работы с файлами

###[json](https://github.com/oscript-library/json)

Порт модуля 1С:JSON Александра Переверзева с сайта infostart.ru

###[logos](https://github.com/oscript-library/logos)

Библиотека логирования в стиле log4j

###[v8runner](https://github.com/oscript-library/v8runner)

Удобная оболочка для запуска команд конфигуратора. Позволяет удобно запускать любые команды пакетного режима Конфигуратора и 1С:Предприятия.

###[tempfiles](https://github.com/oscript-library/tempfiles)

Менеджер управления временными файлами и каталогами

###[tool1cd](https://github.com/oscript-library/tool1cd)

Программная скриптовая обертка для популярной утилиты чтения файловых баз данных tool1cd от [awa](http://infostart.ru/profile/13819/) Удобно использовать, например, для работы с хранилищем 1С.

###[gitsync](https://github.com/oscript-library/gitsync)

Синхронизация хранилища 1С с репозиторием git

###[strings](https://github.com/oscript-library/strings)

Работа со строками. API библиотеки совместимо с API модуля СтроковыеФункцииКлиентСервер из БСП.

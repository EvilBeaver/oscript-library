# Автотестирование

Организовано приемочное тестирование, аналогичное тестированию 1C в проекте [xUnitFor1C](https://github.com/xDrivenDevelopment/xUnitFor1C/wiki)

Основные принципы работы с тестами для скриптов OneScript описаны в [официальной документации OneScript](http://oscript.io/docs/page/testing)

## Запуск всех тестов проекта oscript-library

    oscript finder.os

Для запуска тестов используется скрипт `1testrunner\testrunner.os` из проекта [1testrunner](https://github.com/oscript-library/1testrunner/)

Скрипт выполняет последовательный прогон тестов, переданных в командной строке.

Скрипт `finder.os` выполняет поиск тестов проекта и последовательно прогоняет тесты для каждого найденного файла, запуская `1testrunner\testrunner.os`

## Использование тестирования

Описание механизмов тестирования с примерами смотрите в каталоге [`1testrunner\readme.md`](https://github.com/oscript-library/1testrunner/blob/master/readme.md)

# encoding: utf-8
# language: ru

# gitsync init <PathToStorage> <PathToSrcCatalogue> [options]
# options:
#    -email <EmailDomain>
#        Автоматическое формирование e-mail адресов пользователей хранилища на
#        основании имени пользователя хранилища и указанного домена
#    -v8version <PlatformVersion>
#        Определяет версию платформы
#    -debug <on|off>]
#        Включает отладочный режим с выводом дополнительной информации во время выполнения команды
#    -verbose <on|off>
#        Включает режим вывода подробной информации о выполняемых командой действиях

Функционал: Инициализация каталога исходников конфигурации
    Как Пользователь
    Я хочу создать каталог исходников конфигурации 1С в git-репозитарии
    Чтобы выполнять автоматическую выгрузку конфигураций из хранилища
    
Контекст:
    Дано: Существует каталог хранилища конфигурации 1С "D:\storage"
    И Существует каталог git-репозитария "D:\Project"
    И "src": имя каталога исходников внутри git-репозитария
    
Сценарий: Инициализация каталога исходников, не находящегося внутри git-репозитария
    Дано: Каталог "D:\directory" не является git-репозитарием
    Когда я выполняю команду "gitsync init D:\storage D:\directory\src"
    Тогда мне выдаётся ошибка "Каталог D:\directory\src не принадлежит git-репозитарию"
    И работа команды прекращается.
    
Сценарий: Инициализация каталога исходников в не пустом каталоге
    Дано: Каталог "D:\Project\src" содержит файлы или каталоги
    Когда я выполняю команду "gitsync init D:\storage D:\Project\src"
    Тогда мне выдаётся ошибка "Каталог D:\Project\src не пустой"
    И работа команды прекращается.
    
Сценарий: Инициализация каталога исходников в несуществующем каталоге
    Дано: Каталог "D:\Project\src" не существует
    Когда я выполняю команду "gitsync init D:\storage D:\Project\src"
    Тогда Создаётся каталог "D:\Project\src"
    И В каталоге "D:\Project\src" создаются файлы "AUTHORS" и "VERSION"
    
Сценарий: Инициализация каталога исходников в пустом каталоге
    Дано: Каталог "D:\Project\src" существует
    И Каталог "D:\Project\src" пустой
    Когда я выполняю команду "gitsync init D:\storage D:\Project\src"
    Тогда В каталоге "D:\Project\src" создаются файлы "AUTHORS" и "VERSION"

﻿///////////////////////////////////////////////////////////////////////////////////////////////
//
// Модуль тестирования исходников
//
// (с) BIA Technologies, LLC	
//
///////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos

Перем Правила;				// массив правил
Перем ДеревоОбъектов Экспорт;	// дерево конфигурации
Перем МодулиОбъектов Экспорт;	// модули конфигурации
Перем ТипыБлоков Экспорт;	// Перечисление с типами блоков
Перем Лог;					// лог
Перем КаталогИсходников Экспорт;		// 
Перем СоответствияИмен;			// соответствие латинских и кириллических названий

///////////////////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьТесты(ОбъектТестирования, МенеджерТестирования) Экспорт

	КаталогИсходников = МенеджерТестирования.КаталогИсходников;
	
	ЗагрузитьПравилаПроверки(ОбъектТестирования, МенеджерТестирования);
	
	Если Правила.Количество() > 0 Тогда
	
		Тест = МенеджерТестирования.СоздатьОписаниеТеста("СтатическийАнализКода", "Статический анализ кода", Истина, "Критичная");
		ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение статического анализа кода");
		Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Проанализовал исходники и не обнаружил ошибок", ОбъектТестирования, "ВыполнитьСтатическийАнализКода");
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// Встроенные методы тестирования 
///////////////////////////////////////////////////////////////////////////////////////////////

Функция ВыполнитьСтатическийАнализКода(МенеджерТестирования, Анализатор, ТекущийТест) Экспорт
	
	АргументыТестов = Новый Массив;
	АргументыТестов.Добавить(Анализатор);
	
	Для каждого Правило Из Правила Цикл
		
		ЕстьОшибкаТеста = Ложь;
		ТестКейс = МенеджерТестирования.ДобавитьТестКейс(ТекущийТест, Правило.Наименование);
		ТестКейс.ВремяНачала = ТекущаяДата();
		
		Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, Правило.Описание);
		Шаг.ВремяНачала = ТекущаяДата();
		
		Рефлектор = Новый Рефлектор;
		Если НЕ Рефлектор.МетодСуществует(Правило.Объект, "ВыполнитьПроверку") Тогда
			
			ЕстьОшибкаТеста = Истина;
			ТекстОшибки = "У объекта правила не обнаружен метод 'ВыполнитьПроверку'"
			
		КонецЕсли;
		
		Если НЕ ЕстьОшибкаТеста Тогда
		
			Попытка
			
				ОписаниеОшибки = Рефлектор.ВызватьМетод(Правило.Объект, "ВыполнитьПроверку", АргументыТестов);
						
			Исключение
				
				ОписаниеОшибки = ОписаниеОшибки();
			
			КонецПопытки;
		
		КонецЕсли;
		
		Если Не ПустаяСтрока(ОписаниеОшибки)  Тогда
		
			ЕстьОшибкаТеста = Истина;
			
		КонецЕсли;
		
		Шаг.ВремяОкончания = ТекущаяДата();
		ТестКейс.ВремяОкончания = ТекущаяДата();
		ТестКейс.Важность = Правило.Важность;
		
		Если ЕстьОшибкаТеста Тогда
		
			Шаг.Статус = "провалено";
			ТестКейс.Статус = "провалено";
			ТестКейс.ОписаниеОшибки = ОписаниеОшибки;
			
		Иначе
		
			Шаг.Статус = "успешно";
			ТестКейс.Статус = "успешно";	
		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "";

КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////
// Встроенные методы анализатора
///////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьПравилаПроверки(Анализатор, МенеджерТестирования)

	Правила = Новый Массив;

	КаталогПравил = ОбъединитьПути(МенеджерТестирования.ЛокальныйКаталогГит, "features\rules");
	МассивФайлов = НайтиФайлы(КаталогПравил, "*.os");
	Для Каждого Файл Из МассивФайлов Цикл
		
		Попытка 
		
			Объект = ЗагрузитьСценарий(Файл.ПолноеИмя);
			
		Исключение
		
			Лог.Ошибка("Ошибка загрузки сценария '" + Файл.ПолноеИмя + "': " + ОписаниеОшибки());
			Продолжить;
			
		КонецПопытки;

		Рефлектор = Новый Рефлектор;
		Если НЕ Рефлектор.МетодСуществует(Объект, "ЗагрузитьПравило") Тогда
		
			Лог.Ошибка("Ошибка загрузки правила '" + Файл.ПолноеИмя + "': Отсутствует метод 'ЗагрузитьПравило'");
			Продолжить;
			
		КонецЕсли;
		
		Попытка
		
			Аргументы = Новый Массив;
			Аргументы.Добавить(Анализатор);			
			Аргументы.Добавить(Объект);			
			Рефлектор.ВызватьМетод(Объект, "ЗагрузитьПравило", Аргументы);
		
		Исключение
		
			Лог.Ошибка("Ошибка загрузки правила '" + Файл.ПолноеИмя + "': Ошибка вызова метода 'ЗагрузитьПравило': " + ОписаниеОшибки());
			Продолжить;
		
		КонецПопытки;		
		
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПравило(Наименование, Описание, Объект, Важность = "Нормальная")Экспорт

	Правило = Новый Структура("Наименование, Описание, Объект, Важность", Наименование, Описание, Объект, Важность);
	Правила.Добавить(Правило);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////

Процедура СборИнформацииИзИсходников()Экспорт

	Если ДеревоОбъектов = Неопределено Тогда

		Лог.Отладка("Сбор информации о конфигурации...");
		// структура объектов
		ДеревоОбъектов = Новый ДеревоЗначений;
		ДеревоОбъектов.Колонки.Добавить("Наименование");
		ДеревоОбъектов.Колонки.Добавить("Тип");
		ДеревоОбъектов.Колонки.Добавить("ПолноеНаименование");
		ДеревоОбъектов.Колонки.Добавить("Описание");
		ДеревоОбъектов.Колонки.Добавить("Глобальный"); // для общих модулей
		
		// модули
		МодулиОбъектов = Новый ТаблицаЗначений;
		МодулиОбъектов.Колонки.Добавить("Объект");
		МодулиОбъектов.Колонки.Добавить("Тип");
		МодулиОбъектов.Колонки.Добавить("Содержимое");
		МодулиОбъектов.Колонки.Добавить("ТаблицаБлоков");
		МодулиОбъектов.Колонки.Добавить("Глобальный"); // для общих модулей
		
		// чтение исходников
		ПрочитатьКонфигурациюИзФайлов(ДеревоОбъектов, МодулиОбъектов, КаталогИсходников);
		
		// разбор исходников
		Для Каждого АнализируемыйМодуль Из МодулиОбъектов Цикл
		
			АнализируемыйМодуль.ТаблицаБлоков = ПолучитьТаблицуБлоковМодуля(АнализируемыйМодуль.Содержимое);
		
		КонецЦикла;
		Лог.Отладка("Сбор информации о конфигурации завершен");

	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИмяМетода(Знач ТекстЗаголовкаМетода, Знач Модуль = Неопределено) Экспорт
	
	ТекстЗаголовкаМетода = СокрЛП(ТекстЗаголовкаМетода);
	
	Если СтрНачинаетсяС(НРег(ТекстЗаголовкаМетода), НРег("Функция")) Тогда
		
		ТекстЗаголовкаМетода = Сред(ТекстЗаголовкаМетода, СтрДлина("Функция") + 1);
		
	Иначе 
		
		ТекстЗаголовкаМетода = Сред(ТекстЗаголовкаМетода, СтрДлина("Процедура") + 1);
		
	КонецЕсли; 
	
	ТекстЗаголовкаМетода = СокрЛП(ТекстЗаголовкаМетода);
	ПозицияСкобки = СтрНайти(ТекстЗаголовкаМетода, "(");
	
	ИмяМетода = Лев(ТекстЗаголовкаМетода, ПозицияСкобки - 1);
	Если Модуль <> Неопределено Тогда
		Если Модуль.Глобальный <> ИСТИНА Тогда
			ИмяМетода = Модуль.Объект + "." + ИмяМетода;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИмяМетода;		
	
КонецФункции // ПолучитьИмяМетода

Функция ПроверкаСтрокиПоШаблону(ИсходнаяСтрока, СтрокаПоиска, РегулярноеВыражение = Ложь) Экспорт
	
	Если РегулярноеВыражение Тогда
		RegExp = Новый РегулярноеВыражение(СтрокаПоиска);
	Иначе
		RegExp = Новый РегулярноеВыражение("(^|;|\s|\(|\)|,)" + СтрокаПоиска + "(;|\s|.|,|\(|\))");
	КонецЕсли;
	RegExp.Многострочный = Истина;
	RegExp.ИгнорироватьРегистр = Истина;
	Возврат RegExp.Совпадает(ИсходнаяСтрока);
	
КонецФункции // ПроверкаСтрокиПоШаблону

Процедура ДобавитьОшибку(ТекстОшибок, ОписаниеМодуля, НомерСтроки, СообщениеОбОшибке, СтрокаКода = "", ИмяМетода = "")Экспорт

	Если НЕ ПустаяСтрока(ТекстОшибок) Тогда
	
		ТекстОшибок = ТекстОшибок + Символы.ПС;
		
	КонецЕсли;
	
	ТекстОшибок = ТекстОшибок + ОписаниеМодуля.Объект + "." + ОписаниеМодуля.Тип + ?(ПустаяСтрока(ИмяМетода), "", "." + ИмяМетода) 
		+ ", стр " + Формат(НомерСтроки, "ЧГ=") + ": " + СообщениеОбОшибке + "." 
		+ ?(ПустаяСтрока(СтрокаКода), "", 
			Символы.ПС + "Строка: '" + Лев(СокрЛП(СтрокаКода), 50) + ?(СтрДлина(СокрЛП(СтрокаКода)) > 50, "...", "") + "'");
		
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ Ф-Л
///////////////////////////////////////////////////////////////////////////////////////////////

Процедура ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, Каталог, Уровень = 0, ИмяРодителя = "")
	
	НайденныеФайлы = НайтиФайлы(Каталог, "*");
	Для каждого НайденныйФайл Из НайденныеФайлы Цикл
		
		Если Уровень = 0 И НайденныйФайл.ЭтоФайл() Тогда  
			
			// служебные файлы пока не нужны
			Продолжить;
			
		ИначеЕсли НайденныйФайл.ЭтоКаталог() Тогда
			
			Если НРег(НайденныйФайл.Имя) = НРег("CommonPicture") 			// общие картинки
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("CommonTemplate") 	// общие макеты
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("ScheduledJob") 		// рег задания
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("SessionParameter") 	// параметры сеанса
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("XDTOPackage") 		// пакеты XDTO
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("Language") 			// языки
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("Subsystem") 		// подсистемы
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("Help") 				// справка
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("Item") 				// реквизиты
					ИЛИ НРег(НайденныйФайл.Имя) = НРег("Template") 			// макеты
						Тогда
					
				Продолжить;
				
			КонецЕсли; 
			
			ТипОбъекта = "";
			Если Уровень = 0 Тогда
				
				ТипОбъекта = "Вид";
				
			ИначеЕсли Уровень = 1 Тогда
				
				ТипОбъекта = "Тип";
				
			ИначеЕсли Уровень = 2 Тогда
				
				Если НРег(НайденныйФайл.Имя) = НРег("Command") Тогда
					
					ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1, НайденныйФайл.Имя);
					Продолжить;
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("Form") Тогда
					
					ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1, НайденныйФайл.Имя);
					Продолжить;
					
				КонецЕсли; 
				
			ИначеЕсли Уровень = 3 Тогда
				
				Если НРег(ИмяРодителя) = НРег("Form") Тогда
					
					ТипОбъекта = "Форма";
					
				ИначеЕсли НРег(ИмяРодителя) = НРег("Command") Тогда
					
					ТипОбъекта = "Команда";
					
				КонецЕсли; 
				
			ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("Form") Тогда
					
				ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1, НайденныйФайл.Имя);
				Продолжить;
					
			КонецЕсли; 
			
			Если ПустаяСтрока(ТипОбъекта) Тогда
				
				ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1);
				
			Иначе
				
				СтрокаДерева = КореньДерева.Строки.Добавить();
				СтрокаДерева.Наименование = НайденныйФайл.Имя;
				НовоеИмя = СоответствияИмен.Получить(НайденныйФайл.Имя);
				Если ЗначениеЗаполнено(НовоеИмя) Тогда
					СтрокаДерева.Наименование = НовоеИмя;
				КонецЕсли;
				СтрокаДерева.Тип = ТипОбъекта;
				СтрокаДерева.ПолноеНаименование = ?(Уровень = 0, "", КореньДерева.ПолноеНаименование + ".") + СтрокаДерева.Наименование;
				ПрочитатьКонфигурациюИзФайлов(СтрокаДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1);
				
			КонецЕсли; 
			
		ИначеЕсли Уровень > 1 И НайденныйФайл.ЭтоФайл() Тогда  
			
			Если НРег(НайденныйФайл.Имя) = НРег(КореньДерева.Наименование + ".xml") Тогда
				
				Текст = Новый ТекстовыйДокумент;
				Текст.Прочитать(НайденныйФайл.ПолноеИмя);
				КореньДерева.Описание = Текст.ПолучитьТекст();
				
				КореньДерева.Глобальный = Найти(КореньДерева.Описание, "<Global>true</Global>");
				
			Иначе 
				
				ТипМодуля = "";
				Если НРег(НайденныйФайл.Имя) = НРег("ObjectModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("Module.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("RecordSetModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("ObjectModule.bsl")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("Module.bsl")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("RecordSetModule.bsl") Тогда

						
					Если КореньДерева.Тип = "Форма" 
							ИЛИ КореньДерева.Родитель <> Неопределено 
								И НРег(КореньДерева.Родитель.Наименование) = НРег("CommonForm")
									ИЛИ НРег(КореньДерева.Родитель.Наименование) = НРег("ОбщаяФорма")  Тогда
						
						ТипМодуля = "МодульФормы";
						
					ИначеЕсли КореньДерева.Родитель <> Неопределено 
								И НРег(КореньДерева.Родитель.Наименование) = НРег("CommonModule")
									ИЛИ НРег(КореньДерева.Родитель.Наименование) = НРег("ОбщийМодуль")  Тогда
									
						ТипМодуля = "Модуль";			
						
					Иначе 
						
						ТипМодуля = "МодульОбъекта";
						
					КонецЕсли; 
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("ManagerModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("ValueManagerModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("ManagerModule.bsl")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("ValueManagerModule.bsl") Тогда
					
					ТипМодуля = "МодульМенеджера";
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("CommandModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("CommandModule.bsl") Тогда
					
					ТипМодуля = "МодульКоманды";
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("ManagedApplicationModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("ManagedApplicationModule.bsl") Тогда
					
					ТипМодуля = "МодульУправляемогоПриложения";
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("OrdinaryApplicationModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("OrdinaryApplicationModule.bsl") Тогда
					
					ТипМодуля = "МодульОбычногоПриложения";
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("SessionModule.txt")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("SessionModule.bsl") Тогда
					
					ТипМодуля = "МодульСеанса";
					
				ИначеЕсли НРег(НайденныйФайл.Имя) = НРег("Help.xml")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("Form.xml")
						ИЛИ НРег(НайденныйФайл.Имя) = НРег("Predefined.xml") Тогда
					
					Продолжить;
					
				ИначеЕсли НРег(НайденныйФайл.Расширение) = НРег(".xml") Тогда
					
					// возможно это описание формы
					СтрокаФормы = КореньДерева.Строки.Найти(НайденныйФайл.ИмяБезРасширения, "Наименование");
					Если СтрокаФормы <> Неопределено И ПустаяСтрока(СтрокаФормы.Описание) Тогда
						
						Текст = Новый ТекстовыйДокумент;
						Текст.Прочитать(НайденныйФайл.ПолноеИмя);
						СтрокаФормы.Описание = Текст.ПолучитьТекст();
						СтрокаФормы.Глобальный = Найти(КореньДерева.Описание, "<Global>true</Global>");
						Продолжить;
						
					КонецЕсли; 
					
				Иначе 
						
					Продолжить;
						
				КонецЕсли;
				
				Если Не ПустаяСтрока(ТипМодуля) Тогда
					
					Текст = Новый ТекстовыйДокумент;
					Текст.Прочитать(НайденныйФайл.ПолноеИмя);
					СтрокаМодуля = МодулиОбъектов.Добавить();
					СтрокаМодуля.Объект = КореньДерева.ПолноеНаименование;
					СтрокаМодуля.Тип = ТипМодуля;
					СтрокаМодуля.Содержимое = Текст.ПолучитьТекст();
					СтрокаМодуля.Глобальный = КореньДерева.Глобальный;
					
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе 
			
			ПрочитатьКонфигурациюИзФайлов(КореньДерева, МодулиОбъектов, НайденныйФайл.ПолноеИмя, Уровень + 1);
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры // ПрочитатьКонфигурациюИзФайлов 

Функция ПолучитьТаблицуБлоковМодуля(Знач ОригинальныйТекстМодуля)
	
	///////////////////////////////////////////////////////////////////
	// Идея алгоритма взята из конфигурации "АвтоматизированнаяПроверкаКонфигураций"
	///////////////////////////////////////////////////////////////////

	ТекстМодуля = ОригинальныйТекстМодуля;
	
	ТаблицаБлоков = Новый ТаблицаЗначений;
	ТаблицаБлоков.Колонки.Добавить("Блок");
	ТаблицаБлоков.Колонки.Добавить("НачальнаяСтрока");
	ТаблицаБлоков.Колонки.Добавить("КонечнаяСтрока");
	ТаблицаБлоков.Колонки.Добавить("ЕстьКомментарий");
	ТаблицаБлоков.Колонки.Добавить("ЕстьЭкспорт");
	ТаблицаБлоков.Колонки.Добавить("Текст");
	ТаблицаБлоков.Колонки.Добавить("Описание");
	
	Текст = Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ТекстМодуля);
	ВсегоСтрокМодуля = Текст.КоличествоСтрок();
	
	// Разбиваем текст модуля на блоки.
	ТекущийБлок = Неопределено;
	НачальнаяСтрока = 1;
	КонечнаяСтрока = 1;
	ЭтоКонецБлока = Истина;
	ЕстьЭкспорт = Неопределено;
	ЕстьКомментарий = Ложь;
	
	Для НомерСтроки = 1 По ВсегоСтрокМодуля Цикл
		
		СтрокаМодуля = Текст.ПолучитьСтроку(НомерСтроки);
		СтрокаМодуля = СокрЛП(СтрокаМодуля);
		СтрокаМодуля = ВРег(СтрокаМодуля);
		
		Если НЕ ЭтоКонецБлока Тогда 
			
			НовыйБлок = ТекущийБлок;
			Если НовыйБлок = ТипыБлоков.ОписаниеПеременной Тогда 
				
				ЭтоКонецБлока = СтрНайти(СтрокаМодуля, ";") > 0;
				
			ИначеЕсли НовыйБлок = ТипыБлоков.ЗаголовокПроцедуры 
					ИЛИ НовыйБлок = ТипыБлоков.ЗаголовокФункции Тогда 
				
				ПозицияСкобки = СтрНайти(СтрокаМодуля, ")") > 0;
				ЭтоКонецБлока = ПозицияСкобки > 0;
				ЕстьЭкспорт = Ложь;
				Если ЭтоКонецБлока Тогда 
					ПозицияКомментария = СтрНайти(СтрокаМодуля, "//",, ПозицияСкобки);
					Если ПозицияКомментария > 0 Тогда 
						СтрокаМодуля = СокрП(Лев(СтрокаМодуля, ПозицияКомментария - 1));
					КонецЕсли;
					ЕстьЭкспорт = СтрНайти(СтрокаМодуля, "ЭКСПОРТ",, ПозицияСкобки) > 0;
				КонецЕсли;
				
			Иначе 
				
				ЭтоКонецБлока = Истина;
				
			КонецЕсли;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "//") Тогда
			
			НовыйБлок = ТипыБлоков.Комментарий;
			ЭтоКонецБлока = Истина;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "&") Тогда
			
			НовыйБлок = ТипыБлоков.ДирективаКомпиляции;
			ЭтоКонецБлока = Истина;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "ПЕРЕМ") Тогда
			
			НовыйБлок = ТипыБлоков.ОписаниеПеременной;
			ЭтоКонецБлока = СтрНайти(СтрокаМодуля, ";") > 0;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "ПРОЦЕДУРА") Тогда
			
			НовыйБлок = ТипыБлоков.ЗаголовокПроцедуры;
			ЕстьЭкспорт = Ложь;
			
			ПозицияСкобки = СтрНайти(СтрокаМодуля, ")");
			ЭтоКонецБлока = ПозицияСкобки > 0;
			Если ЭтоКонецБлока Тогда 
				ПозицияКомментария = СтрНайти(СтрокаМодуля, "//",, ПозицияСкобки);
				Если ПозицияКомментария > 0 Тогда 
					СтрокаМодуля = СокрП(Лев(СтрокаМодуля, ПозицияКомментария - 1));
				КонецЕсли;
				ЕстьЭкспорт = СтрНайти(СтрокаМодуля, "ЭКСПОРТ",, ПозицияСкобки) > 0;
			КонецЕсли;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "КОНЕЦПРОЦЕДУРЫ") Тогда
			
			НовыйБлок = ТипыБлоков.ОкончаниеПроцедуры;
			ЭтоКонецБлока = Истина;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "ФУНКЦИЯ") Тогда
			
			НовыйБлок = ТипыБлоков.ЗаголовокФункции;
			ЕстьЭкспорт = Ложь;
			
			ПозицияСкобки = СтрНайти(СтрокаМодуля, ")");
			ЭтоКонецБлока = ПозицияСкобки > 0;
			Если ЭтоКонецБлока Тогда 
				ПозицияКомментария = СтрНайти(СтрокаМодуля, "//",, ПозицияСкобки);
				Если ПозицияКомментария > 0 Тогда 
					СтрокаМодуля = СокрП(Лев(СтрокаМодуля, ПозицияКомментария - 1));
				КонецЕсли;
				ЕстьЭкспорт = СтрНайти(СтрокаМодуля, "ЭКСПОРТ",, ПозицияСкобки) > 0;
			КонецЕсли;
			
		ИначеЕсли СтрНачинаетсяС(СтрокаМодуля, "КОНЕЦФУНКЦИИ") Тогда
			
			НовыйБлок = ТипыБлоков.ОкончаниеФункции;
			ЭтоКонецБлока = Истина;
			
		Иначе
			
			НовыйБлок = ТипыБлоков.Операторы;
			ЭтоКонецБлока = Истина;
			
		КонецЕсли;
		
		Если НовыйБлок = ТекущийБлок Тогда
			
			ЕстьКомментарий = (ЕстьКомментарий ИЛИ (СтрНайти(СтрокаМодуля, "//") > 0));
			КонечнаяСтрока = КонечнаяСтрока + 1;
			
		Иначе
			
			ЭтоЗаголовокМетода = (ТекущийБлок = ТипыБлоков.ЗаголовокПроцедуры) ИЛИ (ТекущийБлок = ТипыБлоков.ЗаголовокФункции);
			
			Если ЗначениеЗаполнено(ТекущийБлок) Тогда
				НоваяЗаписьОБлоке = ТаблицаБлоков.Добавить();
				НоваяЗаписьОБлоке.Блок = ТекущийБлок;
				НоваяЗаписьОБлоке.ЕстьКомментарий = ЕстьКомментарий;
				НоваяЗаписьОБлоке.НачальнаяСтрока = НачальнаяСтрока;
				НоваяЗаписьОБлоке.КонечнаяСтрока  = КонечнаяСтрока;
				НоваяЗаписьОБлоке.ЕстьЭкспорт = ?(ЭтоЗаголовокМетода, ЕстьЭкспорт, Неопределено);
				
				Для ИтБлок = НачальнаяСтрока По КонечнаяСтрока Цикл
					  
					НоваяЗаписьОБлоке.Текст = Строка(НоваяЗаписьОБлоке.Текст) + ?(ПустаяСтрока(НоваяЗаписьОБлоке.Текст), "", Символы.ПС) + Текст.ПолучитьСтроку(ИтБлок);
					
				КонецЦикла;
				
			КонецЕсли;
			
			НачальнаяСтрока = НомерСтроки;
			КонечнаяСтрока  = НомерСтроки;
			ТекущийБлок = НовыйБлок;
			ЕстьКомментарий = (СтрНайти(СтрокаМодуля, "//") > 0);
		КонецЕсли;
		
		Если НомерСтроки = ВсегоСтрокМодуля Тогда
			НоваяЗаписьОБлоке = ТаблицаБлоков.Добавить();
			НоваяЗаписьОБлоке.Блок = ТекущийБлок;
			НоваяЗаписьОБлоке.ЕстьКомментарий = ЕстьКомментарий;
			НоваяЗаписьОБлоке.НачальнаяСтрока = НачальнаяСтрока;
			НоваяЗаписьОБлоке.КонечнаяСтрока  = КонечнаяСтрока;
			Для ИтБлок = НачальнаяСтрока По КонечнаяСтрока Цикл
					  
				НоваяЗаписьОБлоке.Текст = Строка(НоваяЗаписьОБлоке.Текст) + ?(ПустаяСтрока(НоваяЗаписьОБлоке.Текст), "", Символы.ПС) + Текст.ПолучитьСтроку(ИтБлок);
					
			КонецЦикла;

		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерСтроки = 0 По ТаблицаБлоков.Количество() - 1 Цикл
		
		ВыбБлок = ТаблицаБлоков[НомерСтроки];
		Если ВыбБлок.Блок = ТипыБлоков.ЗаголовокПроцедуры 
					ИЛИ ВыбБлок.Блок = ТипыБлоков.ЗаголовокФункции Тогда
				
			ТекНомер = НомерСтроки - 1;
			Пока ТекНомер > 0 Цикл
				
				ПредБлок = ТаблицаБлоков[ТекНомер];
				Если ПредБлок.Блок = ТипыБлоков.ДирективаКомпиляции Тогда
					
					ТекНомер = ТекНомер - 1;
					Продолжить;
					
				ИначеЕсли ПредБлок.Блок = ТипыБлоков.Комментарий Тогда
					
					ВыбБлок.Описание = ПредБлок.Текст;
					
				КонецЕсли;
				Прервать;
									
			КонецЦикла;					
		КонецЕсли;
		
	КонецЦикла;	 
	
	Возврат ТаблицаБлоков;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////
Лог = Логирование.ПолучитьЛог("oscript.app.autotest");

ДеревоОбъектов = Неопределено;
МодулиОбъектов = Неопределено;
Правила = Новый Массив;

ТипыБлоков = Новый Структура("ОписаниеПеременной, ЗаголовокПроцедуры, ОкончаниеПроцедуры, ЗаголовокФункции, ОкончаниеФункции, Операторы, Комментарий, СтрокаТекста, ДирективаКомпиляции", 
								"ОписаниеПеременной", "ЗаголовокПроцедуры", "ОкончаниеПроцедуры", "ЗаголовокФункции", "ОкончаниеФункции", "Операторы", "Комментарий", "СтрокаТекста", "ДирективаКомпиляции");
	
СоответствияИмен = Новый Соответствие;
СоответствияИмен.Вставить("Catalog", "Справочник");
СоответствияИмен.Вставить("Catalogs", "Справочник");
СоответствияИмен.Вставить("Constant", "Константа");
СоответствияИмен.Вставить("Constants", "Константа");
СоответствияИмен.Вставить("Report", "Отчет");
СоответствияИмен.Вставить("Document", "Документ");
СоответствияИмен.Вставить("Documents", "Документ");
СоответствияИмен.Вставить("Reports", "Отчет");
СоответствияИмен.Вставить("InformationRegister", "РегистрСведений");
СоответствияИмен.Вставить("DataProcessor", "Обработка");
СоответствияИмен.Вставить("DataProcessors", "Обработка");
СоответствияИмен.Вставить("CommonModule", "ОбщийМодуль");
СоответствияИмен.Вставить("CommonForm", "ОбщаяФорма");
СоответствияИмен.Вставить("CommonForms", "ОбщаяФорма");
СоответствияИмен.Вставить("Configuration", "Конфигурация");
СоответствияИмен.Вставить("ManagedApplicationModule", "МодульУправляемогоПриложения");
СоответствияИмен.Вставить("OrdinaryApplicationModule", "МодульОбычногоПриложения");

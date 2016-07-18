﻿///////////////////////////////////////////////////////////////////////////////////////////////
//
// Модуль тестирования конфигурации средствами платформы 
//
// (с) BIA Technologies, LLC	
//
///////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьТесты(ОбъектТестирования, МенеджерТестирования)Экспорт

	Тест = МенеджерТестирования.СоздатьОписаниеТеста("ВыполнитьПроверкуКонфигурации", "Выполнение проверки конфигурации средствами платформы",, "Критичная");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение базовой проверки конфигурации", "Нормальная");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииБазовая");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение проверки обработчиков конфигурации", "Средняя");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииОбработчики");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение проверки тонкого клиента", "Низкая");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииТонкийКлиент");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение проверки толстого клиента (обычное приложение)", "Блокирующая");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииТолстыйКлиентОбычноеПриложение");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение проверки толстого клиента (управляемое приложение)", "Нормальная");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииТолстыйКлиентУправляемоеПриложение");
	ТестКейс = МенеджерТестирования.ДобавитьТестКейс(Тест, "Выполнение проверки сервера и внешнего соединения", "Критичная");
	Шаг = МенеджерТестирования.ДобавитьШагТестКейса(ТестКейс, "Запустил конфигуратор в режиме тестирования и получил пустой отчет о проверке", ОбъектТестирования, "ВыполнитьПроверкуКонфигурацииСерверИВнешнее");	

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// Встроенные методы тестирования 
///////////////////////////////////////////////////////////////////////////////////////////////

Функция ВыполнитьПроверкуКонфигурацииБазовая(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-ConfigLogIntegrity");
	ПараметрыЗапуска.Добавить("-IncorrectReferences");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции

Функция ВыполнитьПроверкуКонфигурацииОбработчики(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-UnreferenceProcedures");
	ПараметрыЗапуска.Добавить("-HandlersExistence");
	ПараметрыЗапуска.Добавить("-EmptyHandlers");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции

Функция ВыполнитьПроверкуКонфигурацииТонкийКлиент(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-ThinClient");	
	ПараметрыЗапуска.Добавить("-ExtendedModulesCheck");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции

Функция ВыполнитьПроверкуКонфигурацииТолстыйКлиентОбычноеПриложение(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-ThickClientServerOrdinaryApplication");
	ПараметрыЗапуска.Добавить("-ExtendedModulesCheck");	
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции

Функция ВыполнитьПроверкуКонфигурацииТолстыйКлиентУправляемоеПриложение(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-ThickClientServerManagedApplication");
	ПараметрыЗапуска.Добавить("-ExtendedModulesCheck");	
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции

Функция ВыполнитьПроверкуКонфигурацииСерверИВнешнее(МенеджерТестирования)Экспорт

	Конфигуратор = МенеджерТестирования.Конфигуратор;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/CheckConfig");
	ПараметрыЗапуска.Добавить("-Server");
	ПараметрыЗапуска.Добавить("-ExternalConnectionServer");
	ПараметрыЗапуска.Добавить("-ExtendedModulesCheck");
	
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОтчетОТестировании = Конфигуратор.ВыводКоманды();
	Если НЕ Найти(Врег(ОтчетОТестировании), Врег("Ошибок не обнаружено")) Тогда
		
		Возврат ОтчетОТестировании;		
		
	КонецЕсли;
	
	Возврат "";

КонецФункции


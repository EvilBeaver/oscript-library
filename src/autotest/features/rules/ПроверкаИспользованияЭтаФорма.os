﻿///////////////////////////////////////////////////////////////////////////////////////////////
//
// Правило тестирования исходников
//
// (с) BIA Technologies, LLC	
//
///////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
// ОБЯЗАТЕЛЬНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьПравило(Анализатор, Объект) Экспорт

	Анализатор.ДобавитьПравило(
		"Проверка использования 'ЭтаФорма'", 
		"В конфигурации 8.3 нельзя использовать 'ЭтаФорма', нужно использовать 'ЭтотОбъект'", 
		Объект,
		"Средняя");

КонецПроцедуры

Функция ВыполнитьПроверку(Анализатор) Экспорт

	Анализатор.СборИнформацииИзИсходников();
	
	ТекстОшибок = "";
	Маркер = "ЭтаФорма";
	
	Для каждого Модуль Из Анализатор.МодулиОбъектов Цикл
		
		Если НЕ Найти(Модуль.Содержимое, Маркер) Тогда
				
			Продолжить;
				
		КонецЕсли;
			
		ИмяМетода = "";
		Текст = "";
		БлокОткрыт = ЛОЖЬ;
			
		Для каждого Блок Из Модуль.ТаблицаБлоков Цикл
			
			Если Блок.Блок = Анализатор.ТипыБлоков.ЗаголовокПроцедуры
					ИЛИ Блок.Блок = Анализатор.ТипыБлоков.ЗаголовокФункции Тогда
					
				Если ПустаяСтрока(Текст) Тогда
					
					Текст = Новый ТекстовыйДокумент;
					Текст.УстановитьТекст(Модуль.Содержимое);
					
				КонецЕсли; 
				
				ИмяМетода = Анализатор.ПолучитьИмяМетода(Блок.Текст);
				БлокОткрыт = ИСТИНА;
				
			ИначеЕсли БлокОткрыт 
						И (Блок.Блок = Анализатор.ТипыБлоков.ОкончаниеПроцедуры
							ИЛИ Блок.Блок = Анализатор.ТипыБлоков.ОкончаниеПроцедуры) Тогда 
							
				БлокОткрыт = ЛОЖЬ;
				
			ИначеЕсли БлокОткрыт И Блок.Блок = Анализатор.ТипыБлоков.Операторы Тогда 
				
				Для Ит = Блок.НачальнаяСтрока По Блок.КонечнаяСтрока Цикл
					
					ТекстБлока = Текст.ПолучитьСтроку(Ит);
					Если Анализатор.ПроверкаСтрокиПоШаблону(ТекстБлока, Маркер) Тогда
						
						Анализатор.ДобавитьОшибку(ТекстОшибок, Модуль, Ит, "Используется '" + Маркер + "'", ТекстБлока, ИмяМетода);
						
					КонецЕсли; 
					
				КонецЦикла;
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЦикла; 
	
	Возврат ТекстОшибок;

КонецФункции

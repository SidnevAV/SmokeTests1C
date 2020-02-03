﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыМетаданных = ОбъектыМетаданных();
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		Если ОбъектМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Ложь);
		Для Каждого Элемент Из ОбъектМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоНетПравНаУдалениеИлиПометкуПредопределенныхДанных", 
				НаборТестов.ПараметрыТеста(Элемент.ПолноеИмя), 
				Элемент.Имя);	
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоНетПравНаУдалениеИлиПометкуПредопределенныхДанных(ПолноеИмяМетаданных) Экспорт
		
	Результат = ПроверитьЧтоНетПравНаУдалениеИлиПометкуПредопределенныхДанных(ПолноеИмяМетаданных);
	ТекстШаблона = НСтр("ru = 'Есть право на удаление или пометку предопределенных объектов:%1'");
	ТекстРезультата = СтрШаблон(ТекстШаблона, Результат);
	Утверждения.Проверить(Результат = "", ТекстРезультата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧтоНетПравНаУдалениеИлиПометкуПредопределенныхДанных(ПолноеИмяМетаданных)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	Результат = "";
	
	ПроверитьПрава(Результат, ОбъектМетаданных);
	
	Возврат Результат;

КонецФункции // ПроверитьЧтоЕстьПраваНаЧтениеСервер()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПроверитьПрава(Результат, ОбъектМетаданных)
	
	СписокПрав = СписокПрав();
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если Метаданные.ОсновныеРоли.Содержит(Роль) Тогда
			Продолжить;
		КонецЕсли;
				
		Для Каждого Право Из СписокПрав Цикл
			ЕстьПраво = ПравоДоступа(Право, ОбъектМетаданных, Роль);
			Если ЕстьПраво Тогда
				Результат = Результат + Символы.ПС + Роль.Имя + " право: " + Право;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
		
	Возврат Результат;
	
КонецФункции 

&НаСервереБезКонтекста
Функция СписокПрав()

	СписокПрав = Новый Массив;
	СписокПрав.Добавить("ИнтерактивноеУдалениеПредопределенныхДанных");
	СписокПрав.Добавить("ИнтерактивнаяПометкаУдаленияПредопределенныхДанных");
	СписокПрав.Добавить("ИнтерактивноеСнятиеПометкиУдаленияПредопределенныхДанных");
	СписокПрав.Добавить("ИнтерактивноеУдалениеПомеченныхПредопределенныхДанных");
	
	Возврат СписокПрав;

КонецФункции 

&НаСервереБезКонтекста
Функция ОбъектыМетаданных()
		
	ОбъектыМетаданных = Новый Структура;
	ОбъектыМетаданных.Вставить("Справочники", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыСчетов", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовРасчета", Новый Массив);
		
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("Имя", ОбъектМетаданных.Имя);
			СтруктураЭлемента.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
			ОбъектыМетаданных[Элемент.Ключ].Добавить(СтруктураЭлемента);	
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции // ОбъектыМетаданных()

&НаСервере
Функция ИмяТеста()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста()) Тогда
		ВыполнятьТест = Настройки.Параметры[ИмяТеста()];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти
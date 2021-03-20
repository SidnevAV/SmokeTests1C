﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ВыводитьИсключения;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(КонтекстЯдра, ИмяТеста());
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппыТестов = ГруппыТестов();
	
	Для Каждого ГруппаТестов Из ГруппыТестов Цикл
		
		ОбъектыМетаданных = ОбъектыМетаданных(ГруппаТестов.ИмяОбъектовМетаданных, ОтборПоПрефиксу, ПрефиксОбъектов);
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектыМетаданных);
		Иначе
			МассивТестов = ОбъектыМетаданных;
		КонецЕсли;
		Если МассивТестов.Количество() Тогда
			НаборТестов.НачатьГруппу(ГруппаТестов.ИмяГруппыТестов, Истина);
		КонецЕсли;	
		
		Для Каждого Тест Из МассивТестов Цикл	
			
			Пояснение = НСтр("ru = 'Проверка привилегированного режима объекта'");
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", Тест.ПолноеИмя, Пояснение);
			ПараметрыТеста = НаборТестов.ПараметрыТеста(Тест.ПолноеИмя, ГруппаТестов.ПроверяемыеСвойства);
			
			НаборТестов.Добавить(Тест.ИмяПроцедуры, ПараметрыТеста, ИмяТеста);
				
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
	
	ПрефиксОбъектов = "";
	ОтборПоПрефиксу = Ложь;
	ИсключенияИзПроверок = Новый Соответствие;
	ВыводитьИсключения = Истина;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);		
	КонецЕсли;
		
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьПривилегированныйРежимОбъекта(ПолноеИмяМетаданных, ПроверяемыеСвойства) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	
	Результат = ПроверитьПривилегированныйРежимОбъекта(ПолноеИмяМетаданных, ПроверяемыеСвойства);
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения(ПолноеИмяМетаданных, Результат));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПривилегированныйРежимОбъекта(ПолноеИмяМетаданных, ПроверяемыеСвойства)
	
	Результат = "";
	СтроковыеУтилиты = СтроковыеУтилиты();	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	
	Для Каждого ПроверяемоеСвойство Из ПроверяемыеСвойства Цикл
		Если ОбъектМетаданных[ПроверяемоеСвойство.Ключ] <> ПроверяемоеСвойство.Значение Тогда
			ТекстОшибки = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
							"%1: %2", 
							ПроверяемоеСвойство.Ключ, 
							ОбъектМетаданных[ПроверяемоеСвойство.Ключ]);
			Разделитель = ?(ЗначениеЗаполнено(Результат), Символы.ПС, "");
			Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1%2%3", Результат, Разделитель, ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ЭтоУстаревшийОбъектМетаданных(ПолноеИмяМетаданных) Тогда
		ШаблонСообщения = НСтр("ru = '""%1"" исключен из проверки, устаревший объект.'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Если ИсключенИзПроверок(ВРег(ПолноеИмяМетаданных)) Тогда
		ШаблонСообщения = НСтр("ru = '""%1"" исключен из проверки.'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ИсключенИзПроверок(ПолноеИмяМетаданных)
	
	Результат = Ложь;
	МассивСтрокИмени = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПолноеИмяМетаданных, ".");
	ИслючениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИслючениеВсехОбъектов)) <> Неопределено Тогда
		Результат = Истина;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных, Результат)

	ШаблонСообщения = НСтр("ru = 'У объект метаданных ""%1"" установлены свойства: %2%3'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
						ШаблонСообщения, 
						ПолноеИмяМетаданных, 
						Символы.ПС, 
						Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ГруппыТестов()

	ГруппыТестов = Новый Массив;
	
	ПроверяемыеСвойства = Новый Структура;
	ПроверяемыеСвойства.Вставить("ПривилегированныйРежимПриПолучении", Истина);
	
	СтруктураГруппыТестов = Новый Структура;
	СтруктураГруппыТестов.Вставить("ИмяГруппыТестов", "Функциональные опции");
	СтруктураГруппыТестов.Вставить("ИмяОбъектовМетаданных", "ФункциональныеОпции");
	СтруктураГруппыТестов.Вставить("ПроверяемыеСвойства", ПроверяемыеСвойства);
	
	ГруппыТестов.Добавить(СтруктураГруппыТестов);
	
	ПроверяемыеСвойства = Новый Структура;
	ПроверяемыеСвойства.Вставить("ПривилегированныйРежимПриПроведении", Истина);
	ПроверяемыеСвойства.Вставить("ПривилегированныйРежимПриОтменеПроведения", Истина);
	
	СтруктураГруппыТестов = Новый Структура;
	СтруктураГруппыТестов.Вставить("ИмяГруппыТестов", "Документы");
	СтруктураГруппыТестов.Вставить("ИмяОбъектовМетаданных", "Документы");
	СтруктураГруппыТестов.Вставить("ПроверяемыеСвойства", ПроверяемыеСвойства);
	
	ГруппыТестов.Добавить(СтруктураГруппыТестов);
	
	ПроверяемыеСвойства = Новый Структура;
	ПроверяемыеСвойства.Вставить("ПривилегированныйРежимПриСозданииЗадач", Истина);
	
	СтруктураГруппыТестов = Новый Структура;
	СтруктураГруппыТестов.Вставить("ИмяГруппыТестов", "Бизнес процессы");
	СтруктураГруппыТестов.Вставить("ИмяОбъектовМетаданных", "БизнесПроцессы");
	СтруктураГруппыТестов.Вставить("ПроверяемыеСвойства", ПроверяемыеСвойства);
	
	ГруппыТестов.Добавить(СтруктураГруппыТестов);
	
	Возврат ГруппыТестов;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ИмяОбъектовМетаданных, ОтборПоПрефиксу, ПрефиксОбъектов)
	
	ПроведениеЗапретить = Метаданные.СвойстваОбъектов.Проведение.Запретить;
	МассивОбъектовМетаданных = Новый Массив;
	
	Для Каждого ОбъектМетаданных Из Метаданные[ИмяОбъектовМетаданных] Цикл
		Если Метаданные.Документы.Содержит(ОбъектМетаданных) 
			И ОбъектМетаданных.Проведение = ПроведениеЗапретить Тогда
			Продолжить;
		КонецЕсли;
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьЭлементКоллекцииОбъектовМетаданных(
			МассивОбъектовМетаданных, 
			ОбъектМетаданных.Имя, 
			ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	Возврат МассивОбъектовМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, Имя, ПолноеИмя)

	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("ИмяПроцедуры", "ТестДолжен_ПроверитьПривилегированныйРежимОбъекта");
	СтруктураЭлемента.Вставить("Имя", Имя);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоУстаревшийОбъектМетаданных(ИмяОбъектаМетаданных)
	Возврат СтрНайти(ВРег(ИмяОбъектаМетаданных), "УДАЛИТЬ");
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции

&НаКлиенте
Функция ИмяТеста()
	
	Если Не ЗначениеЗаполнено(Объект.ИмяТеста) Тогда
		Объект.ИмяТеста = ИмяТестаНаСервере();
	КонецЕсли;
	
	Возврат Объект.ИмяТеста;
	
КонецФункции

&НаСервере
Функция ИмяТестаНаСервере()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	Настройки(КонтекстЯдра, ИмяТеста());
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти
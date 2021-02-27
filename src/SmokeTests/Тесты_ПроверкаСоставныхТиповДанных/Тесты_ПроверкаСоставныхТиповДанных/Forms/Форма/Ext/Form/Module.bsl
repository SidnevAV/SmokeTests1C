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
Перем ПропускатьОбъектыСПрефиксомУдалить;
&НаКлиенте
Перем ПроверятьДополнительныеРеквизиты;
&НаКлиенте
Перем ТипыОбъектСсылка;
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
	
	ОбъектыМетаданных = ОбъектыМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;
		Если МассивТестов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Истина);
		Для Каждого Тест Из МассивТестов Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьСоставнойТип", 
				НаборТестов.ПараметрыТеста(Тест.ПолноеИмя), 
				Тест.ИмяТеста);	
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
	ПропускатьОбъектыСПрефиксомУдалить = Ложь;
	ПроверятьДополнительныеРеквизиты = Истина;
	ИсключенияИзПроверок = Новый Соответствие;
	ВыводитьИсключения = Истина;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("ПропускатьОбъектыСПрефиксомУдалить") Тогда
		ПропускатьОбъектыСПрефиксомУдалить = Настройки.ПропускатьОбъектыСПрефиксомУдалить;
	КонецЕсли;
	
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);		
	КонецЕсли;
		
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("ПроверятьДополнительныеРеквизиты") Тогда
		ПроверятьДополнительныеРеквизиты = Настройки.ПроверятьДополнительныеРеквизиты;
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
Процедура ТестДолжен_ПроверитьСоставнойТип(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
		
	Результат = ПроверитьПримитивныеТипыВСоставномТипе(ПолноеИмяМетаданных);
	ШаблонСообщения = НСтр("ru = 'Объект ""%1"" содержит ссылочные и примитивные типы'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТипыОбъектСсылка) Тогда
		ТипыОбъектСсылка = ТипыОбъектСсылка();
	КонецЕсли;

	Результат = ПроверитьТипыОбъектСсылкаВСоставномТипе(ПолноеИмяМетаданных, ТипыОбъектСсылка);
	ШаблонСообщения = НСтр("ru = 'Объект ""%1"" содержит типы: %2'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных, Результат);
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПримитивныеТипыВСоставномТипе(ПолноеИмяМетаданных)
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	ПримитывныеТипыДанных = ПримитывныеТипыДанных();
	СодержитПримитивныйТипДанных = Ложь;
	ТипыОбъектаМетаданных = ОбъектМетаданных.Тип.Типы();
	ТипыДляУдаления = Новый Массив;
	Результат = Новый Массив;
	
	Для Каждого ТипДанных Из ТипыОбъектаМетаданных Цикл
		ТипДанныхСтрока = Строка(ТипДанных);
		Если ПримитывныеТипыДанных.Получить(ТипДанныхСтрока) <> Неопределено Тогда
			ТипыДляУдаления.Добавить(ТипДанных);
			СодержитПримитивныйТипДанных = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не СодержитПримитивныйТипДанных Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для Каждого Элемент Из ТипыОбъектаМетаданных Цикл		
		Если ТипыДляУдаления.Найти(Элемент) = Неопределено Тогда			
			Возврат Ложь;			
		КонецЕсли;		
	КонецЦикла;	

	Возврат Истина;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПроверитьТипыОбъектСсылкаВСоставномТипе(ПолноеИмяМетаданных, ТипыОбъектСсылка)
	
	Результат = "";
	СтрокаЛюбаяСсылка = "ЛюбаяСсылка";
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	
	Если ПроверитьТипОбъектСсылкаВСоставномТипе(ОбъектМетаданных, ТипыОбъектСсылка[СтрокаЛюбаяСсылка]) Тогда
		Возврат СтрокаЛюбаяСсылка;
	КонецЕсли;
	
	Для каждого ТипОбъектСсылка Из ТипыОбъектСсылка Цикл
		Если ТипОбъектСсылка.Ключ = СтрокаЛюбаяСсылка Тогда
			Продолжить;
		КонецЕсли;
		Если ПроверитьТипОбъектСсылкаВСоставномТипе(ОбъектМетаданных, ТипОбъектСсылка.Значение) Тогда
			Разделитель = ?(ЗначениеЗаполнено(Результат), ", ", "");
			Результат = Результат + Разделитель + ТипОбъектСсылка.Ключ;
		КонецЕсли;	
	КонецЦикла;
 		
	Возврат Результат;

КонецФункции 

&НаСервереБезКонтекста
Функция ПроверитьТипОбъектСсылкаВСоставномТипе(ОбъектМетаданных, ТипОбъектСсылка)
	
	ТипыОбъектаМетаданных = ОбъектМетаданных.Тип.Типы();
	ТипОбъектСсылкаКоличествоТипов = ТипОбъектСсылка.Количество();
	ТипыОбъектаМетаданныхКоличествоТипов = ТипыОбъектаМетаданных.Количество();
	КоличествоОбработанныхТипов = 0;
	
	Если ТипОбъектСсылкаКоличествоТипов = 1 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипыОбъектаМетаданныхКоличествоТипов < ТипОбъектСсылкаКоличествоТипов Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Для Каждого ТипДанных Из ТипыОбъектаМетаданных Цикл
		Если ТипОбъектСсылка.Получить(ТипДанных) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		КоличествоОбработанныхТипов = КоличествоОбработанныхТипов + 1;
		Если КоличествоОбработанныхТипов = ТипОбъектСсылкаКоличествоТипов Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
 		
	Возврат Ложь;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ПропускатьОбъектыСПрефиксомУдалить И СтрНайти(ВРег(ПолноеИмяМетаданных), ".УДАЛИТЬ") > 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки, префикс ""Удалить""'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	СтрокаПоиска = ВРег("ДополнительныеРеквизиты");
	Если Не ПроверятьДополнительныеРеквизиты И СтрНайти(ВРег(ПолноеИмяМетаданных), СтрокаПоиска) > 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки, доп. реквизиты не проверяются'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Если ИсключенИзПроверок(ВРег(ПолноеИмяМетаданных)) <> Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
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

	Исключения = Новый Соответствие;
	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Исключения.Вставить(Тест, Истина);
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Тест Из МассивТестов Цикл
 		Если Исключения.Получить(Тест) = Истина Тогда
			Продолжить;
		КонецЕсли;
		Результат.Добавить(Тест);
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов)
	
	СоответсвиеОбъектовМетаданных = СоответсвиеОбъектовМетаданных();
	СтроковыеУтилиты = СтроковыеУтилиты();
		
	СтруктураОбъектовМетаданных = Новый Структура;
	Для Каждого ЭлементСоответствия Из СоответсвиеОбъектовМетаданных Цикл
		СтруктураОбъектовМетаданных.Вставить(ЭлементСоответствия.Ключ, Новый Массив);
	КонецЦикла;
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[ЭлементСтруктурыОбъектовМетаданных.Ключ] Цикл
						
			ВидПроверки = СоответсвиеОбъектовМетаданных.Получить(ЭлементСтруктурыОбъектовМетаданных.Ключ);
			
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("ВидПроверки", ВидПроверки);
			Параметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			Параметры.Вставить("ЭлементСтруктурыОбъектовМетаданных", ЭлементСтруктурыОбъектовМетаданных);
			Параметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу);
			Параметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			Параметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);

			ОбработатьОбъектМетаданных(Параметры);
									
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Процедура ОбработатьОбъектМетаданных(Параметры)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	ВидПроверки = Параметры.ВидПроверки;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ЭлементСтруктурыОбъектовМетаданных = Параметры.ЭлементСтруктурыОбъектовМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	ВидыПроверок = ВидыПроверок();
	
	Если ВидПроверки = ВидыПроверок.СамОбъект И ОбъектМетаданных.Тип.Типы().Количество() > 1 Тогда
		
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
			Возврат;
		КонецЕсли;
		
		ДобавитьЭлементКоллекцииОбъектовМетаданных(
			СтроковыеУтилиты,
			СтруктураОбъектовМетаданных[ЭлементСтруктурыОбъектовМетаданных.Ключ], 
			ОбъектМетаданных.ПолноеИмя());

	ИначеЕсли ВидПроверки = ВидыПроверок.СвойстваОбъекта Тогда
			
		ВключитьВсеЭлементы = ОтборПоПрефиксу И ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов);
		
		мПараметры = Новый Структура;
		мПараметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
		мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
		мПараметры.Вставить("ИмяМетаданных", ЭлементСтруктурыОбъектовМетаданных.Ключ);
		мПараметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу И Не ВключитьВсеЭлементы);
		мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
		мПараметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
		
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Измерения");
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Ресурсы");
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Реквизиты");
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "РеквизитыАдресации");
		ОбработатьТабличныеЧастиОбъектаМетаданных(мПараметры, "ТабличныеЧасти");
					
	Иначе
		Возврат;			
	КонецЕсли;	

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьТабличныеЧастиОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ВключитьВсеЭлементы = ОтборПоПрефиксу И ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов);
		
		мПараметры = Новый Структура;
		мПараметры.Вставить("ОбъектМетаданных", ЭлементКоллекции);
		мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
		мПараметры.Вставить("ИмяМетаданных", ИмяМетаданных);
		мПараметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу И Не ВключитьВсеЭлементы);
		мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
		мПараметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
		
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Реквизиты");
							
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		Если ЭлементКоллекции.Тип.Типы().Количество() > 1 Тогда
			
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтроковыеУтилиты,
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ЭлементКоллекции.ПолноеИмя());
				
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(СтроковыеУтилиты, Коллекция, ПолноеИмя)

	Описание = НСтр("ru = 'Проверка составного типа данных'");
	ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", ПолноеИмя, Описание);
	
	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция СоответсвиеОбъектовМетаданных()

	ВидыПроверки = ВидыПроверок();
	
	СоответсвиеОбъектовМетаданных = Новый Соответствие;
	                                 
	СоответсвиеОбъектовМетаданных.Вставить("ПараметрыСеанса", ВидыПроверки.СамОбъект);
	СоответсвиеОбъектовМетаданных.Вставить("ОбщиеРеквизиты", ВидыПроверки.СамОбъект);
	СоответсвиеОбъектовМетаданных.Вставить("ПланыОбмена", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("КритерииОтбора", ВидыПроверки.СамОбъект);
	СоответсвиеОбъектовМетаданных.Вставить("ХранилищаНастроек", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("Константы", ВидыПроверки.СамОбъект);
	СоответсвиеОбъектовМетаданных.Вставить("Справочники", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("Документы", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("ПланыВидовХарактеристик", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("ПланыСчетов", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("ПланыВидовРасчета", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("РегистрыСведений", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("РегистрыНакопления", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("РегистрыБухгалтерии", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("РегистрыРасчета", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("БизнесПроцессы", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("Задачи", ВидыПроверки.СвойстваОбъекта);
	СоответсвиеОбъектовМетаданных.Вставить("ВнешниеИсточникиДанных", ВидыПроверки.СвойстваОбъекта);
	
	Возврат СоответсвиеОбъектовМетаданных;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ВидыПроверок()
	Возврат Новый Структура("СамОбъект,СвойстваОбъекта", "Объект", "Свойства");
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ПримитывныеТипыДанных()

	ПримитывныеТипыДанных = Новый Соответствие;
	ПримитывныеТипыДанных.Вставить("Число", Истина);
	ПримитывныеТипыДанных.Вставить("Строка", Истина);
	ПримитывныеТипыДанных.Вставить("Булево", Истина);
	ПримитывныеТипыДанных.Вставить("Дата", Истина);
	
	Возврат ПримитывныеТипыДанных;

КонецФункции

&НаСервереБезКонтекста
Функция ТипыОбъектСсылка()

	СтрокаЛюбаяСсылка = "ЛюбаяСсылка";
	
	ТипыОбъектСсылка = Новый Структура;
	ТипыОбъектСсылка.Вставить(СтрокаЛюбаяСсылка, Новый Соответствие);
	
	ТипыОбъектовМетаданных = Новый Структура;
	ТипыОбъектовМетаданных.Вставить("СправочникСсылка", Справочники.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ДокументСсылка", Документы.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ПеречислениеСсылка", Перечисления.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ПланВидовХарактеристикСсылка", ПланыВидовХарактеристик.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ПланСчетовСсылка", ПланыСчетов.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ПланВидовРасчетаСсылка", ПланыВидовРасчета.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("БизнесПроцессСсылка", БизнесПроцессы.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить(
		"ТочкаМаршрутаБизнесПроцессаСсылка", БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().Типы());
	ТипыОбъектовМетаданных.Вставить("ЗадачаСсылка", Задачи.ТипВсеСсылки().Типы());
	ТипыОбъектовМетаданных.Вставить("ПланОбменаСсылка", ПланыОбмена.ТипВсеСсылки().Типы());
		
	Для Каждого ЭлементСтруктурыТипыОбъектовМетаданных Из ТипыОбъектовМетаданных Цикл
		ТипыОбъектСсылка.Вставить(ЭлементСтруктурыТипыОбъектовМетаданных.Ключ, Новый Соответствие);
		Для Каждого ТипДанных Из ЭлементСтруктурыТипыОбъектовМетаданных.Значение Цикл
			ТипыОбъектСсылка[СтрокаЛюбаяСсылка].Вставить(ТипДанных, Истина);
			ТипыОбъектСсылка[ЭлементСтруктурыТипыОбъектовМетаданных.Ключ].Вставить(ТипДанных, Истина);
		КонецЦикла;
	КонецЦикла;
			
	Возврат ТипыОбъектСсылка;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
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
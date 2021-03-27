﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ВыводитьИсключения;
&НаКлиенте
Перем ПропускатьОбъектыСПрефиксомУдалить;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем КаталогиВнешнихОтчетов;
&НаКлиенте
Перем ИмяФормыОтчета;
&НаКлиенте
Перем ИмяФормыНастроек;
&НаКлиенте
Перем ИмяФормыВарианта;

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
		
	мОтчеты = Отчеты(ПрефиксОбъектов, ОтборПоПрефиксу);
	Если Не ВыводитьИсключения Тогда
		МассивТестов = УбратьИсключения(мОтчеты);
	Иначе
		МассивТестов = мОтчеты;
	КонецЕсли;
	Если МассивТестов.Количество() Тогда
		НаборТестов.НачатьГруппу("Отчеты", Истина);	
	КонецЕсли;
	Для Каждого Тест Из МассивТестов Цикл
		ИмяПроцедуры = "ТестДолжен_ПроверитьОсновныеФормыОтчетов";
		ИмяТеста = КонтекстЯдра.СтрШаблон_("%1 [%2]", Тест.ПолноеИмя, НСтр("ru = 'Проверка основных форм отчета'")); 
		НаборТестов.Добавить(ИмяПроцедуры, НаборТестов.ПараметрыТеста(Тест.Имя, Тест.ПолноеИмя), ИмяТеста);	
	КонецЦикла;
	
	Для Каждого КаталогВнешнихОтчетов Из КаталогиВнешнихОтчетов Цикл
		ФайлыВнешнихОтчетов = НайтиФайлы(КаталогВнешнихОтчетов, "*.erf", Истина);
		Если ФайлыВнешнихОтчетов.Количество() Тогда
			ИмяГруппы = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("Внешние отчеты [%1]", КаталогВнешнихОтчетов);
			Если Не ВыводитьИсключения Тогда
				МассивТестов = УбратьИсключения(ФайлыВнешнихОтчетов);
			Иначе
				МассивТестов = ФайлыВнешнихОтчетов;
			КонецЕсли;
			Если МассивТестов.Количество() Тогда
				НаборТестов.НачатьГруппу(ИмяГруппы, Истина);	
			КонецЕсли;
			Для Каждого Тест Из МассивТестов Цикл 
				ИмяПроцедуры = "ТестДолжен_ПроверитьОсновныеФормыВнешнихОтчетов";
				ИмяТеста = КонтекстЯдра.СтрШаблон_("%1 [%2]", Тест.ПолноеИмя, НСтр("ru = 'Проверка основных форм отчета'"));
				НаборТестов.Добавить(ИмяПроцедуры, НаборТестов.ПараметрыТеста(Тест.Имя, Тест.ПолноеИмя), ИмяТеста);	
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормыОтчета = "";
	ИмяФормыНастроек = "";
	ИмяФормыВарианта = "";
	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	ВыводитьИсключения = Истина;
	ПропускатьОбъектыСПрефиксомУдалить = Ложь;
	КаталогиВнешнихОтчетов = Новый Массив;
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("ФормаОтчета") Тогда
		ИмяФормыОтчета = Настройки.ФормаОтчета;
	КонецЕсли;
	
	Если Настройки.Свойство("ФормаНастроек") Тогда
		ИмяФормыНастроек = Настройки.ФормаНастроек;
	КонецЕсли;
	
	Если Настройки.Свойство("ФормаВарианта") Тогда
		ИмяФормыВарианта = Настройки.ФормаВарианта;
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
	
	Если Настройки.Свойство("ПропускатьОбъектыСПрефиксомУдалить") Тогда
		ПропускатьОбъектыСПрефиксомУдалить = Настройки.ПропускатьОбъектыСПрефиксомУдалить;
	КонецЕсли;
	
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);
	КонецЕсли;
	
	Если Настройки.Свойство("КаталогиВнешнихОтчетов") Тогда
		КаталогиВнешнихОтчетов = ОбработатьОтносительныеПути(Настройки.КаталогиВнешнихОтчетов, КонтекстЯдра);
	КонецЕсли;
	
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьОсновныеФормыОтчетов(ИмяОтчета, ПолноеИмяОтчета) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяОтчета);
	
	Результат = ПроверитьОсновныеФормыОтчетов(ИмяОтчета, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта);
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ИмяОтчета, Результат));
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения(ИмяОтчета, Результат));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОсновныеФормыОтчетов(ИмяОтчета, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта)
	
	Отчет = Метаданные.Отчеты.Найти(ИмяОтчета);	
	Результат = "";
	
	ПроверитьФормыОтчета(Результат, Отчет, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ТестДолжен_ПроверитьОсновныеФормыВнешнихОтчетов(ИмяОтчета, ПолноеИмяОтчета) Экспорт
	
	ПропускатьТест = ПропускатьТест(СтроковыеУтилиты.ПодставитьПараметрыВСтроку("ВнешнийОтчет.%1", ИмяОтчета));
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяОтчета);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
	
	Результат = ПроверитьОсновныеФормыВнешнихОтчетов(Адрес, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта);
	Если Результат.ТекстОшибки <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ИмяОтчета, Результат.ТекстОшибки));
	ИначеЕсли Не Результат.ОтчетПодключен Тогда
		Утверждения.Проверить(Результат.ОтчетПодключен, Результат.ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат.ТекстОшибки = "", ТекстСообщения(ИмяОтчета, Результат.ТекстОшибки));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОсновныеФормыВнешнихОтчетов(Адрес, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта)
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("ОтчетПодключен", Ложь);
	
	Попытка
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
		ИмяФайлаОтчета = ПолучитьИмяВременногоФайла("erf");
		ДвоичныеДанные.Записать(ИмяФайлаОтчета);
		ВнешнийОтчет = ВнешниеОтчеты.Создать(ИмяФайлаОтчета).Метаданные();	
		Результат.ОтчетПодключен = Истина;
		УдалитьФайлы(ИмяФайлаОтчета);
	Исключение
		УдалитьФайлы(ИмяФайлаОтчета);
		Результат.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Результат;
	КонецПопытки;
	
	СтроковыеУтилиты = СтроковыеУтилиты();
	ТекстОшибки = "";
	
	ПроверитьФормыОтчета(Результат, ВнешнийОтчет, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта);
	
	Результат.ТекстОшибки = ТекстОшибки;
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Процедура ПроверитьФормыОтчета(Результат, Отчет, ИмяФормыОтчета, ИмяФормыНастроек, ИмяФормыВарианта)

	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Если Метаданные.ОсновнаяФормаОтчета = Неопределено И Отчет.ОсновнаяФорма = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		ШаблонОшибки = НСтр("ru = '%1%2 форма отчета'");
		Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);
	Иначе
		Если ЗначениеЗаполнено(ИмяФормыОтчета) Тогда
			ФормаОтчета = Метаданные.ОбщиеФормы.Найти(ИмяФормыОтчета);
			Если Не (Метаданные.ОсновнаяФормаОтчета = ФормаОтчета Или Отчет.ОсновнаяФорма = ФормаОтчета) Тогда
				Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
				ШаблонОшибки = НСтр("ru = '%1%2 некорректная форма отчета'");
				Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаНастроекОтчета = Неопределено И Отчет.ОсновнаяФормаНастроек = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		ШаблонОшибки = НСтр("ru = '%1%2 форма настроек отчета'");
		Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);
	Иначе
		Если ЗначениеЗаполнено(ИмяФормыНастроек) Тогда
			ФормаНастроек = Метаданные.ОбщиеФормы.Найти(ИмяФормыНастроек);
			Если Не (Метаданные.ОсновнаяФормаОтчета = ФормаНастроек Или Отчет.ОсновнаяФормаНастроек = ФормаНастроек) Тогда
				Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
				ШаблонОшибки = НСтр("ru = '%1%2 некорректная форма настроек отчета'");
				Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаВариантаОтчета = Неопределено И Отчет.ОсновнаяФормаВарианта = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		ШаблонОшибки = НСтр("ru = '%1%2 форма варианта отчета'");
		Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);
	Иначе
		Если ЗначениеЗаполнено(ИмяФормыВарианта) Тогда
			ФормаВарианта = Метаданные.ОбщиеФормы.Найти(ИмяФормыВарианта);
			Если Не (Метаданные.ОсновнаяФормаОтчета = ФормаВарианта Или Отчет.ОсновнаяФормаВарианта = ФормаВарианта) Тогда
				Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
				ШаблонОшибки = НСтр("ru = '%1%2 некорректная форма варианта отчета'");
				Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонОшибки, Результат, Разделитель);	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ИмяОтчета)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ВРег(ИмяОтчета)) Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки.'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяОтчета);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Если ПропускатьОбъектыСПрефиксомУдалить = Истина И СтрНайти(ВРег(ИмяОтчета), ".УДАЛИТЬ") > 0 Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки, префикс ""Удалить""'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообшения, ИмяОтчета);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ТекстСообщения(ИмяОтчета, Результат)

	ШаблонСообщения = НСтр("ru = 'Для отчета ""%1"" не указаны формы:%2.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяОтчета, Результат);
	
	Возврат ТекстСообщения;

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
Функция ОбработатьОтносительныеПути(Знач ОтносительныеПути, КонтекстЯдра)

	Результат = Новый Массив;
	
	Для Каждого ОтносительныйПуть Из ОтносительныеПути Цикл
		
		Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
			ОтносительныйПуть = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
									"%1%2", 
									КонтекстЯдра.Объект.КаталогПроекта, 
									Сред(ОтносительныйПуть, 2));
		КонецЕсли;
		
		ОтносительныйПуть = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
		Если Результат.Найти(ОтносительныйПуть) = Неопределено Тогда
			Результат.Добавить(ОтносительныйПуть);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Результат;

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

&НаСервереБезКонтекста
Функция Отчеты(ПрефиксОбъектов, ОтборПоПрефиксу)

	Результат = Новый Массив;
	
	Для Каждого Отчет Из Метаданные.Отчеты Цикл
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(Отчет.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		СтруктураОтчета = Новый Структура;
		СтруктураОтчета.Вставить("Имя", Отчет.Имя);
		СтруктураОтчета.Вставить("Синоним", Отчет.Синоним);
		СтруктураОтчета.Вставить("ПолноеИмя", Отчет.ПолноеИмя());
		Результат.Добавить(СтруктураОтчета);
	КонецЦикла;	
	
	Возврат Результат;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции

#КонецОбласти
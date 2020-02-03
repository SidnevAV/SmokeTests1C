﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем КаталогиВнешнихОтчетов;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
		
	НаборТестов.НачатьГруппу("Отчеты", Истина);
	мОтчеты = Отчеты(ПрефиксОбъектов, ОтборПоПрефиксу);	
	Для Каждого Отчет Из мОтчеты Цикл
		ИмяПроцедуры = "ТестДолжен_ПроверитьОсновныеФормыОтчетов";
		НаборТестов.Добавить(ИмяПроцедуры, НаборТестов.ПараметрыТеста(Отчет.Имя, Отчет.ПолноеИмя), Отчет.Имя);	
	КонецЦикла;
	
	Для Каждого КаталогВнешнихОтчетов Из КаталогиВнешнихОтчетов Цикл
		ФайлыВнешнихОтчетов = НайтиФайлы(КаталогВнешнихОтчетов, "*.erf", Истина);
		Если ФайлыВнешнихОтчетов.Количество() Тогда
			НаборТестов.НачатьГруппу(СтрШаблон("Внешние отчеты [%1]", КаталогВнешнихОтчетов), Истина);
			Для Каждого ФайлВнешнегоОтчета Из ФайлыВнешнихОтчетов Цикл 
				ИмяПроцедуры = "ТестДолжен_ПроверитьОсновныеФормыВнешнихОтчетов";
				НаборТестов.Добавить(
				ИмяПроцедуры, 
				НаборТестов.ПараметрыТеста(ФайлВнешнегоОтчета.Имя, ФайлВнешнегоОтчета.ПолноеИмя), 
				ФайлВнешнегоОтчета.Имя);	
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
	
	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	КаталогиВнешнихОтчетов = Новый Массив;
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("Префикс") Тогда
		ПрефиксОбъектов = Настройки.Параметры.Префикс;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("КаталогиВнешнихОтчетов") Тогда
		КаталогиВнешнихОтчетов = ОбработатьОтносительныеПути(
									Настройки[ИмяТеста()].КаталогиВнешнихОтчетов, 
									КонтекстЯдра);
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки[ИмяТеста()].ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзпроверок Цикл
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
	
	Результат = ПроверитьОсновныеФормыОтчетов(ИмяОтчета);
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения(ИмяОтчета, Результат));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОсновныеФормыОтчетов(ИмяОтчета)
	
	Отчет = Метаданные.Отчеты.Найти(ИмяОтчета);	
	Результат = "";
	
	Если Метаданные.ОсновнаяФормаОтчета = Неопределено И Отчет.ОсновнаяФорма = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		Результат = СтрШаблон(НСтр("ru = '%1%2 форма отчета'"), Результат, Разделитель);	
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаНастроекОтчета = Неопределено И Отчет.ОсновнаяФормаНастроек = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		Результат = СтрШаблон(НСтр("ru = '%1%2 форма настроек отчета'"), Результат, Разделитель);	
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаВариантаОтчета = Неопределено И Отчет.ОсновнаяФормаВарианта = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ",", "");
		Результат = СтрШаблон(НСтр("ru = '%1%2 форма варианта отчета'"), Результат, Разделитель);	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ТестДолжен_ПроверитьОсновныеФормыВнешнихОтчетов(ИмяОтчета, ПолноеИмяОтчета) Экспорт
	
	ПропускатьТест = ПропускатьТест(СтрШаблон("ВнешнийОтчет.%1", ИмяОтчета));
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяОтчета);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
	
	Результат = ПроверитьОсновныеФормыВнешнихОтчетов(Адрес);
	Если Результат.ТекстОшибки <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	ИначеЕсли Не Результат.ОтчетПодключен Тогда
		Утверждения.Проверить(Результат.ОтчетПодключен, Результат.ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат.ТекстОшибки = "", ТекстСообщения(ИмяОтчета, Результат.ТекстОшибки));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОсновныеФормыВнешнихОтчетов(Адрес)
	
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
	
	Если Метаданные.ОсновнаяФормаОтчета = Неопределено И ВнешнийОтчет.ОсновнаяФорма = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат.ТекстОшибки), ",", "");
		Результат.ТекстОшибки = СтрШаблон(НСтр("ru = '%1%2 форма отчета'"), Результат.ТекстОшибки, Разделитель);	
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаНастроекОтчета = Неопределено И ВнешнийОтчет.ОсновнаяФормаНастроек = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат.ТекстОшибки), ",", "");
		Результат.ТекстОшибки = СтрШаблон(НСтр("ru = '%1%2 форма настроек отчета'"), Результат.ТекстОшибки, Разделитель);	
	КонецЕсли;
	
	Если Метаданные.ОсновнаяФормаВариантаОтчета = Неопределено И ВнешнийОтчет.ОсновнаяФормаВарианта = Неопределено Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат.ТекстОшибки), ",", "");
		Результат.ТекстОшибки = СтрШаблон(НСтр("ru = '%1%2 форма варианта отчета'"), Результат.ТекстОшибки, Разделитель);	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ИмяОтчета)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ИмяОтчета)) <> Неопределено Тогда
		Результат.ТекстСообщения = СтрШаблон(НСтр("ru = 'Объект ""%1"" исключен из проверки.'"), ИмяОтчета);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСообщения(ИмяОтчета, Результат)

	ШаблонСообщения = НСтр("ru = 'Для отчета ""%1"" не указаны формы:%2.'");
	ТекстСообщения = СтрШаблон(ШаблонСообщения, ИмяОтчета, Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбработатьОтносительныеПути(Знач ОтносительныеПути, КонтекстЯдра)

	Результат = Новый Массив;
	
	Для Каждого ОтносительныйПуть Из ОтносительныеПути Цикл
		
		Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
			ОтносительныйПуть = СтрШаблон("%1%2", КонтекстЯдра.Объект.КаталогПроекта, Сред(ОтносительныйПуть, 2));
		КонецЕсли;
		
		ОтносительныйПуть = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
		Если Результат.Найти(ОтносительныйПуть) = Неопределено Тогда
			Результат.Добавить(ОтносительныйПуть);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

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
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

#КонецОбласти
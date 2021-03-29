﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем КонфигурацииПоставщика;

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
		
	Если Не ЗначениеЗаполнено(КонфигурацииПоставщика) Тогда
		Возврат;
	КонецЕсли;
	
	Пояснение = НСтр("ru = 'Проверка объектов метаданных конфигурации поставщика'");
	СтруктураКонфигурацийПоставщика = СтруктураКонфигурацийПоставщика(КонфигурацииПоставщика);
	
	Для Каждого СтруктураКонфигурацииПоставщика Из СтруктураКонфигурацийПоставщика Цикл
		
		ИмяКонфигурации = СтруктураКонфигурацииПоставщика.Ключ;
		НаборТестов.НачатьГруппу(ИмяКонфигурации, Истина);
		
		Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураКонфигурацииПоставщика.Значение Цикл
							
			ИмяТеста = ЭлементСтруктурыОбъектовМетаданных.Ключ;
			МассивОбъектовМетаданных = ЭлементСтруктурыОбъектовМетаданных.Значение;
			КоличествоОбъектов = МассивОбъектовМетаданных.Количество();
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.%2 [%3]: %4", ИмяКонфигурации, ИмяТеста, КоличествоОбъектов, Пояснение);
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьОбъектМетаданныхКонфигурацииПоставщика", 
				НаборТестов.ПараметрыТеста(МассивОбъектовМетаданных), 
				ИмяТеста);
			
		КонецЦикла;
		
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(мКонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключенияИзПроверок = Новый Соответствие;
	КонфигурацииПоставщика = Новый Структура;
	ПлагинНастроек = мКонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
				
	Если Настройки.Свойство("КонфигурацияПоставщика") Тогда
		ПрочитатьФайлКонфигурацииПоставщика(мКонтекстЯдра, Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлКонфигурацииПоставщика(мКонтекстЯдра, Настройки)
	
	#Если Не ВебКлиент Тогда
	ПутьФайлаКонфигурацииПоставщика = Настройки.КонфигурацияПоставщика;
	ПутьФайлаКонфигурацииПоставщика = ОбработатьОтносительныйПуть(ПутьФайлаКонфигурацииПоставщика, мКонтекстЯдра);
		
	Файл = Новый Файл(ПутьФайлаКонфигурацииПоставщика);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеJson = Новый ЧтениеJSON;
	ЧтениеJson.ОткрытьФайл(ПутьФайлаКонфигурацииПоставщика);	
	КонфигурацииПоставщика = ПрочитатьJSON(ЧтениеJson);
	ЧтениеJson.Закрыть();
		
	Файл = Неопределено;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных) Экспорт
	
	Результат = ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных);	
	Утверждения.Проверить(Результат = "", ТекстСообщения(Результат));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных)

	Результат = "";
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Для Каждого ОбъектМетаданных Из МассивОбъектовМетаданных Цикл
		Если Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных.ПолноеИмя) = Неопределено Тогда		
			Разделитель = ?(ЗначениеЗаполнено(Результат), Символы.ПС, "");
			Результат = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
							"%1%2%3", 
							Результат, 
							Разделитель, 
							ОбъектМетаданных.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ТекстСообщения(Результат)

	ШаблонСообщения = НСтр("ru = 'Не удалось найти объекты конфигурации поставщика: %1%2'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, Символы.ПС, Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция СтруктураКонфигурацийПоставщика(КонфигурацииПоставщика)
	
	СоответствиеИменОбъектовМетаданных = СоответствиеИменОбъектовМетаданных();
	СтруктураОбъектовМетаданных = Новый Структура;
	СтруктураКонфигурацийПоставщика = Новый Структура;
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Для Каждого КонфигурацияПоставщика Из КонфигурацииПоставщика Цикл
		
		СтруктураОбъектовМетаданных = Новый Структура;
		
		Для Каждого КоллекцияОбъектовМетаданных Из КонфигурацияПоставщика.Значение Цикл
						
			ИмяКоллекции = СоответствиеИменОбъектовМетаданных.Получить(КоллекцияОбъектовМетаданных.Ключ);
			
			СтруктураОбъектовМетаданных.Вставить(КоллекцияОбъектовМетаданных.Ключ, Новый Массив);
			
			Для Каждого ОбъектаМетаданных Из КоллекцияОбъектовМетаданных.Значение Цикл
				
				ИмяОбъектаМетаданных = ИмяОбъектаМетаданных(ОбъектаМетаданных, СтроковыеУтилиты);
				
				ДобавитьЭлементКоллекцииОбъектовМетаданных(
					СтруктураОбъектовМетаданных[КоллекцияОбъектовМетаданных.Ключ], 
					ИмяОбъектаМетаданных, 
					СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.%2", ИмяКоллекции, ИмяОбъектаМетаданных));

			КонецЦикла;
				
		КонецЦикла;
		
		СтруктураКонфигурацийПоставщика.Вставить(КонфигурацияПоставщика.Ключ, СтруктураОбъектовМетаданных);
		
	КонецЦикла;
		
	Возврат СтруктураКонфигурацийПоставщика;

КонецФункции 

&НаСервереБезКонтекста
Функция СоответствиеИменОбъектовМетаданных()
	
	СоответствиеИменОбъектовМетаданных = Новый Соответствие;
	
	СоответствиеИменОбъектовМетаданных.Вставить("Подсистемы", "Подсистема");    
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеМодули", "ОбщийМодуль");
	СоответствиеИменОбъектовМетаданных.Вставить("ПараметрыСеанса", "ПараметрСеанса");
	СоответствиеИменОбъектовМетаданных.Вставить("Роли", "Роль");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеРеквизиты", "ОбщиеРеквизит");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыОбмена", "ПланОбмена");
	СоответствиеИменОбъектовМетаданных.Вставить("КритерииОтбора", "КритерийОтбора");
	СоответствиеИменОбъектовМетаданных.Вставить("ПодпискиНаСобытия", "ПодпискаНаСобытие");
	СоответствиеИменОбъектовМетаданных.Вставить("РегламентныеЗадания", "РегламентноеЗадание");
	СоответствиеИменОбъектовМетаданных.Вставить("ФункциональныеОпции", "ФункциональнаяОпция");	
	СоответствиеИменОбъектовМетаданных.Вставить("ПараметрыФункциональныхОпций", "ПараметрФункциональныхОпций");
	СоответствиеИменОбъектовМетаданных.Вставить("ОпределяемыеТипы", "ОпределяемыйТип");
	СоответствиеИменОбъектовМетаданных.Вставить("ХранилищаНастроек", "ХранилищеНастроек");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеФормы", "ОбщаяФорма");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеКоманды", "ОбщаяКоманда");
	СоответствиеИменОбъектовМетаданных.Вставить("ГруппыКоманд", "ГруппаКоманд");
	СоответствиеИменОбъектовМетаданных.Вставить("Интерфейсы", "Интерфейс");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеМакеты", "ОбщийМакет");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеКартинки", "ОбщаяКартинка");
	СоответствиеИменОбъектовМетаданных.Вставить("ПакетыXDTO", "ПакетXDTO");
	СоответствиеИменОбъектовМетаданных.Вставить("WebСервисы", "WebСервис");
	СоответствиеИменОбъектовМетаданных.Вставить("HTTPСервисы", "HTTPСервис");  
	СоответствиеИменОбъектовМетаданных.Вставить("WSСсылки", "WSСсылка");
	СоответствиеИменОбъектовМетаданных.Вставить("ЭлементыСтиля", "ЭлементСтиля");
	СоответствиеИменОбъектовМетаданных.Вставить("Стили", "Стиль");
	СоответствиеИменОбъектовМетаданных.Вставить("Языки", "Язык");    
	СоответствиеИменОбъектовМетаданных.Вставить("Константы", "Константа");
	СоответствиеИменОбъектовМетаданных.Вставить("Справочники", "Справочник");
	СоответствиеИменОбъектовМетаданных.Вставить("Документы", "Документ");
	СоответствиеИменОбъектовМетаданных.Вставить("ЖурналыДокументов", "ЖурналДокументов");
	СоответствиеИменОбъектовМетаданных.Вставить("Перечисления", "Перечисление");
	СоответствиеИменОбъектовМетаданных.Вставить("Отчеты", "Отчет");
	СоответствиеИменОбъектовМетаданных.Вставить("Обработки", "Обработка");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыВидовХарактеристик", "ПланВидовХарактеристик");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыСчетов", "ПланСчетов");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыВидовРасчета", "ПланВидовРасчета");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыСведений", "РегистрСведений");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыНакопления", "РегистрНакопления");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыБухгалтерии", "РегистрБухгалтерии");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыРасчета", "РегистрРасчета");
	СоответствиеИменОбъектовМетаданных.Вставить("БизнесПроцессы", "БизнесПроцесс");
	СоответствиеИменОбъектовМетаданных.Вставить("Задачи", "Задача");
	СоответствиеИменОбъектовМетаданных.Вставить("ВнешниеИсточникиДанных", "ВнешнийИсточникиДанных");
	
	Возврат СоответствиеИменОбъектовМетаданных;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяОбъектаМетаданных(ОбъектаМетаданных, СтроковыеУтилиты)
	
	МассивСтрок = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ОбъектаМетаданных, ".");
	СоответствиеИменСвойств = СоответствиеИменСвойств();
	ШагОбходаСтрок = 2;
	ИндексСтроки = 1;
	
	Пока ИндексСтроки <= МассивСтрок.Количество() - 1 Цикл
		ЗначениеСтроки = МассивСтрок.Получить(ИндексСтроки);
		Если СоответствиеИменСвойств.Получить(ЗначениеСтроки) <> Неопределено Тогда
			МассивСтрок.Установить(ИндексСтроки, СоответствиеИменСвойств.Получить(ЗначениеСтроки));
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + ШагОбходаСтрок;
	КонецЦикла;
	
	ИмяОбъектаМетаданных = СтроковыеУтилиты.СтрокаИзМассиваПодстрок(МассивСтрок, ".");	
	
	Возврат ИмяОбъектаМетаданных;
	
КонецФункции

&НаСервереБезКонтекста
Функция СоответствиеИменСвойств()
	
	СоответствиеИменСвойств = Новый Соответствие;
	
	СоответствиеИменСвойств.Вставить("Подсистемы", "Подсистема");
	СоответствиеИменСвойств.Вставить("Реквизиты", "Реквизит");
	СоответствиеИменСвойств.Вставить("Формы", "Форма");
	СоответствиеИменСвойств.Вставить("ТабличныеЧасти", "ТабличнаяЧасть");
	СоответствиеИменСвойств.Вставить("Макеты", "Макет");
	СоответствиеИменСвойств.Вставить("Команды", "Команда");
	СоответствиеИменСвойств.Вставить("ЗначенияПеречисления", "ЗначениеПеречисления");
	СоответствиеИменСвойств.Вставить("Измерения", "Измерение");
	СоответствиеИменСвойств.Вставить("Ресурсы", "Ресурс");
	СоответствиеИменСвойств.Вставить("РеквизитыАдресации", "РеквизитАдресации");
	СоответствиеИменСвойств.Вставить("Графы", "Графа");
	СоответствиеИменСвойств.Вставить("Операции", "Операция");
	СоответствиеИменСвойств.Вставить("Параметры", "Параметр");
		
	Возврат СоответствиеИменСвойств;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, Имя, ПолноеИмя)

	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("Имя", Имя);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиенте
Функция ОбработатьОтносительныйПуть(Знач ОтносительныйПуть, КонтекстЯдра)

	Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
		ОтносительныйПуть = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
								"%1%2", 
								КонтекстЯдра.Объект.КаталогПроекта, 
								Сред(ОтносительныйПуть, 2));
	КонецЕсли;
	
	Результат = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
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
	ПутьНастройки = ИмяТеста();
	Настройки(КонтекстЯдра, ПутьНастройки);
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
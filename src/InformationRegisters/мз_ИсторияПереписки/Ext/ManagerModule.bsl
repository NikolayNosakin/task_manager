﻿
Процедура ДобавитьСообщение(ОбъектПереписки, ТекстСообщения, Пользователь = неопределено) Экспорт
	
	Если ПустаяСтрока(ТекстСообщения) Тогда 
		Возврат;
	КонецЕсли;
	
	Период = ТекущаяДатаСеанса();
	НаборЗаписей = РегистрыСведений.мз_ИсторияПереписки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задача.Установить(ОбъектПереписки);	
	Если Пользователь = Неопределено Тогда
		НаборЗаписей.Отбор.Пользователь.Установить(Пользователи.ТекущийПользователь());
	Иначе
		НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	КонецЕсли;
	
	НаборЗаписей.Отбор.Период.Установить(Период);
	
	строкаЗаписи = НаборЗаписей.Добавить();
	строкаЗаписи.Период = Период;
	строкаЗаписи.Задача = ОбъектПереписки;
	Если Пользователь = Неопределено Тогда
		строкаЗаписи.Пользователь = Пользователи.ТекущийПользователь();
	Иначе
		строкаЗаписи.Пользователь = Пользователь;
	КонецЕсли;	
	строкаЗаписи.ТекстСообщения = ТекстСообщения;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьМассивСообщений(ОбъектПереписки, ФильтрПереписки = 1) Экспорт
	
	МассивСообщений = Новый Массив;
	
	Если ЗначениеЗаполнено(ОбъектПереписки)Тогда
		ВнешнийАдресИБ = ПараметрыСеанса.мз_ВнешнийАдресИБ;
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсторияПереписки.Период КАК Период,
		|	ИсторияПереписки.Задача КАК Задача,
		|	ИсторияПереписки.Пользователь КАК Пользователь,
		|	ИсторияПереписки.ТекстСообщения КАК ТекстСообщения
		|ИЗ
		|	РегистрСведений.мз_ИсторияПереписки КАК ИсторияПереписки
		|ГДЕ
		|	ИсторияПереписки.Задача = &Задача
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
		Запрос.УстановитьПараметр("Задача", ОбъектПереписки.Ссылка);					                                             
		Выборка = Запрос.Выполнить().Выбрать();	
		Пока Выборка.Следующий() Цикл 
			СтруктураСообщения = Новый Структура("Пользователь, Период, ТекстСообщения");
			ЗаполнитьЗначенияСвойств(СтруктураСообщения, Выборка);
			Отбор = Новый Структура;
			Отбор.Вставить("Период",Выборка.Период);
			Отбор.Вставить("Пользователь",Выборка.Пользователь);
			Отбор.Вставить("Задача",Выборка.Задача);			
			Ключ = РегистрыСведений.мз_ИсторияПереписки.СоздатьКлючЗаписи(Отбор);   
			СтруктураСообщения.Вставить("Изменить", ВнешнийАдресИБ + ПолучитьНавигационнуюСсылку(Ключ));
			МассивСообщений.Добавить(СтруктураСообщения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивСообщений; 
	
КонецФункции

Функция СформироватьИсториюПерепискиHTML(МассивСообщений) Экспорт
	
	ДокументHTML = "";
	Макет = ПолучитьМакет("ИсторияПереписки");
	ДокументHTML = ДокументHTML + ПолучитьТекстОбласти(Макет, "НачалоДокумента");

	ШаблонСообщение = ПолучитьТекстОбласти(Макет, "Сообщение");
	Для Каждого Сообщение из МассивСообщений Цикл
		ОбработатьТекстВФорматHTML(Сообщение.ТекстСообщения);
		Сообщение.Период = Формат(Сообщение.Период, "ДФ='dd MMMM yyyy HH:mm:ss'");
		ДокументHTML = ДокументHTML + СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонСообщение, Сообщение); 
	КонецЦикла;
	
	ШаблонСообщение = ПолучитьТекстОбласти(Макет, "КонецДокумента");
	ДокументHTML = ДокументHTML + ШаблонСообщение;
	Возврат ДокументHTML;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТекстОбласти(Макет, ИмяОбласти)
	
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	ТекстОбласти = Область.ПолучитьТекст(); 
	ТекстОбласти = СтрЗаменить(ТекстОбласти, "#Область " + ИмяОбласти, "");
	ТекстОбласти = СтрЗаменить(ТекстОбласти, "#КонецОбласти", "");
	Возврат ТекстОбласти;	
	
КонецФункции

Процедура ОбработатьТекстВФорматHTML(ТекстСообщения)
	
	ПереносСтрокиHTML = "<br/>";
	ПробелHTML = "&nbsp";
	ТекстСообщения = СтрЗаменить(ТекстСообщения, Символы.ПС, ПереносСтрокиHTML);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, " ", ПробелHTML);
	//**GM->
	ИндексОткрытияСсылки = Найти(ТекстСообщения, "<a");
	Если ИндексОткрытияСсылки <> 0 Тогда
		ИндексЗакрытияСсылки = Найти(ТекстСообщения, "/a>");
		ЧислоСимволов = ИндексЗакрытияСсылки - ИндексОткрытияСсылки;
		ПодстрокаСсылки = Сред(ТекстСообщения, ИндексОткрытияСсылки,ЧислоСимволов+3);
		СтрокаСодержаниеСсылки = Сред(ТекстСообщения,ИндексОткрытияСсылки+3,ЧислоСимволов-4);
		ИндексНомера = Найти(СтрокаСодержаниеСсылки,"№");
		Если СтрокаСодержаниеСсылки <> "" И ИндексНомера = 1 Тогда
			НомерДокумента = Сред(СтрокаСодержаниеСсылки,2);
			ПолучитьСсылкуПоНомеру = Справочники.ДоговорыКонтрагентов.НайтиПоРеквизиту("Номер",НомерДокумента);
			НавигСсылкаОбъекта = ПолучитьНавигационнуюСсылку(ПолучитьСсылкуПоНомеру);
			//СтрокаССсылкой = " href=" + "e1c://server/WIN-ASUCN7LDFVL/UTK_UT_TEST1#" + НавигСсылкаОбъекта;
			УстановитьПривилегированныйРежим(Истина);
			СтрокаССсылкой = " href=" + Константы.ПутьСервераДляНавигационнойСсылки.Получить() + НавигСсылкаОбъекта;
			УстановитьПривилегированныйРежим(Ложь);
			ПодстрокаСсылкиСПутем = СтрЗаменить(ПодстрокаСсылки,"<a>","<a"+СтрокаССсылкой+">");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,ПодстрокаСсылки,ПодстрокаСсылкиСПутем);
		КонецЕсли;
	КонецЕсли;
	//**GM<-
	
КонецПроцедуры

#КонецОбласти

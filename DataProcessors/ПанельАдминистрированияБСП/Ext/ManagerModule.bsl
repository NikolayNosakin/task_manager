﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.2.1.12",
		"Подсистема.НастройкаИАдминистрирование",
		"Подсистема.Администрирование",
		Библиотека);
	
КонецПроцедуры

// Определяет разделы, в которых доступна панель отчетов.
//   Подробнее - см. описание процедуры ИспользуемыеРазделы
//   общего модуля ВариантыОтчетов.
//
// Параметры:
//   Разделы - СписокЗначений
//
Процедура ПриОпределенииРазделовСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование, НСтр("ru = 'Отчеты администратора'"));
	
КонецПроцедуры

// Параметры:
//  Разделы - см. ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОтчетами.Разделы
//
Процедура ПриОпределенииРазделовСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

// Параметры:
//  Разделы - см. ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОтчетами.Разделы
//
Процедура ПриОпределенииРазделовСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

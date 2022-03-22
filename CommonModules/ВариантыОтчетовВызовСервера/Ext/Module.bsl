﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//  Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка дополнительного отчета.
//  КлючВарианта - Строка - имя варианта дополнительного отчета.
//
Процедура ПриПодключенииОтчета(ПараметрыОткрытия) Экспорт
	
	ВариантыОтчетов.ПриПодключенииОтчета(ПараметрыОткрытия);
	
КонецПроцедуры

// Получает тип субконто счета по его номеру.
//
// Параметры:
//  Счет - ПланСчетовСсылка - ссылка счета.
//  НомерСубконто - Число - номер субконто.
//
// Возвращаемое значение:
//   ОписаниеТипов - тип субконто.
//   Неопределено - если не удалось получить тип субконто (нет такого субконто или нет прав).
//
Функция ТипСубконто(Счет, НомерСубконто) Экспорт
	
	Если Счет = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	ОбъектМетаданных = Счет.Метаданные();
	
	Если Не Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПланСчетовВидыСубконто.ВидСубконто.ТипЗначения КАК Тип
	|ИЗ
	|	&ПолноеИмяТаблицы КАК ПланСчетовВидыСубконто
	|ГДЕ
	|	ПланСчетовВидыСубконто.Ссылка = &Ссылка
	|	И ПланСчетовВидыСубконто.НомерСтроки = &НомерСтроки");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяТаблицы", ОбъектМетаданных.ПолноеИмя() + ".ВидыСубконто");
	
	Запрос.УстановитьПараметр("Ссылка", Счет);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСубконто);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выборка.Тип;
	
КонецФункции

// Параметры:
//   ОписаниеФайлов - Массив из Структура:
//     * Хранение - Строка
//     * Имя - Строка
//
// Возвращаемое значение:
//   Массив из Структура
//
Функция СвойстваВариантовОтчетовИзФайлов(ОписаниеФайлов) Экспорт 
	
	Возврат ВариантыОтчетов.СвойстваВариантовОтчетовИзФайлов(ОписаниеФайлов);
	
КонецФункции

// Параметры:
//   ОписаниеФайла - Структура:
//     * Хранение - Строка
//     * Имя - Строка 
//   ВариантОтчетаОснование - СправочникСсылка.ВариантыОтчетов 
//
// Возвращаемое значение:
//   см. ВариантыОтчетов.СвойстваВариантаОтчетаИзФайла
//
Функция СвойстваВариантаОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование) Экспорт 
	
	Возврат ВариантыОтчетов.СвойстваВариантаОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование);
	
КонецФункции

// Параметры:
//   ВыбранныеПользователи - см. ВариантыОтчетов.ПоделитьсяПользовательскимиНастройками.ВыбранныеПользователи
//   ОписаниеНастроек - см. ВариантыОтчетов.ПоделитьсяПользовательскимиНастройками.ШаблонОписанияНастроек
//
Процедура ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек) Экспорт 
	
	ВариантыОтчетов.ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек);
	
КонецПроцедуры

// Параметры:
//  ВариантОтчета - см. ВариантыОтчетов.ЭтоПредопределенныйВариантОтчета.ВариантОтчета
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоПредопределенныйВариантОтчета(ВариантОтчета) Экспорт 
	
	Возврат ВариантыОтчетов.ЭтоПредопределенныйВариантОтчета(ВариантОтчета);
	
КонецФункции

#КонецОбласти

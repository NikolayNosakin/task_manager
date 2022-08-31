﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если Не ПометкаУдаления И ЗначениеЗаполнено(Статус) И Не Отказ Тогда		
		ВыполнитьДвижениеПоРегиструСтатусов(Ссылка,ДополнительныеСвойства);		
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьДвижениеПоРегиструСтатусов(ДокСсылка,ДопСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	мз_ИсторияСтатусовЗадач.Статус
	|ИЗ
	|	РегистрСведений.мз_ИсторияСтатусовЗадач.СрезПоследних(&Период, Задача = &Задача) КАК мз_ИсторияСтатусовЗадач";
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.УстановитьПараметр("Задача", ДокСсылка);

	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаРезультатаЗапроса = РезультатЗапроса.Выбрать();

	Если ВыборкаРезультатаЗапроса.Количество() = 0 Тогда
		ДвиженияПоРегиструСтатусов(ДокСсылка,ДопСвойства);
	Иначе
		ВыборкаРезультатаЗапроса.Следующий();
		СсылкаСтатус = ДокСсылка.Статус;
		Если ВыборкаРезультатаЗапроса.Статус <> СсылкаСтатус Тогда
			ДвиженияПоРегиструСтатусов(ДокСсылка,ДопСвойства);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ДвиженияПоРегиструСтатусов(ДокСсылка,ДопСвойства) Экспорт
	
	НаборЗаписей = РегистрыСведений.мз_ИсторияСтатусовЗадач.СоздатьНаборЗаписей();
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Задача = ДокСсылка;
	НоваяСтрока.Период = ТекущаяДата();
	НоваяСтрока.Статус = ДокСсылка.Статус;
	НоваяСтрока.Пользователь = Пользователи.ТекущийПользователь();
	Если ДопСвойства.Свойство("ПричинаСменыСтатуса") Тогда
		НоваяСтрока.Комментарий = ДопСвойства.ПричинаСменыСтатуса;                  
	КонецЕсли;	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

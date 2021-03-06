
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФизЛицо = Пользователи.ТекущийПользователь().ФизическоеЛицо;
	
	Если Объект.Ссылка.Пустая() Тогда		
		Объект.Постановщик = ФизЛицо;
		Объект.ДатаНачала = ТекущаяДата();
		Объект.Статус = Справочники.СтатусыЗадач.Новая;
		Объект.Клиент = ФизЛицо.Клиент;
		Участник1 = Объект.Участники.Добавить();
		Участник1.Участник = ФизЛицо;
		Элементы.ФорматированныйТекст.АктивизироватьПоУмолчанию = Истина;
	Иначе
		Элементы.ТекстСообщения.АктивизироватьПоУмолчанию = Истина;
		ИсторияПереписки = ПолучитьИсторияПереписки();
	КонецЕсли;
	
	Исполнитель = ФизЛицо.Исполнитель;
	Элементы.Клиент.Видимость = Исполнитель;
	Элементы.Постановщик.Доступность = Исполнитель;
	
	Если Объект.Постановщик = ФизЛицо Тогда
		Элементы.ФорматированныйТекст.Доступность = Истина;
		Элементы.Заголовок.Доступность = Истина;
		Элементы.КоманднаяПанельРедактирования.Видимость = Истина;
	Иначе
		Элементы.ФорматированныйТекст.ТолькоПросмотр = Истина;
		Элементы.КоманднаяПанельРедактирования.Видимость = Ложь;
		Элементы.Заголовок.Видимость = Ложь;
		Элементы.ПодзадачиОписание.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УстановитьЗаголовокФормы();	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Исполнитель", Истина));
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);	
	Элементы.Исполнители.ПараметрыВыбора = НовыеПараметры;
		
	ТЗ = Объект.Исполнители.Выгрузить();
	Исполнители.ЗагрузитьЗначения(ТЗ.ВыгрузитьКолонку("Исполнитель"));
	ТЗ = Объект.Участники.Выгрузить();
	Участники.ЗагрузитьЗначения(ТЗ.ВыгрузитьКолонку("Участник"));
	
	ПользовательВИсполнителях();
	
	УстановитьОтборВУчастниках();
	
КонецПроцедуры

&НаСервере
Процедура ПользовательВИсполнителях()
	
	ВидимостьЭлемента =  Исполнители.НайтиПоЗначению(Пользователи.ТекущийПользователь().ФизическоеЛицо) = Неопределено;
	Элементы.ГруппаОценка.Видимость = НЕ ВидимостьЭлемента;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборВУчастниках()
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Клиент", Объект.Клиент));
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);	
	Элементы.Участники.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПерепискиДокументСформирован(Элемент)
	#Если НЕ МобильныйКлиент Тогда
		ДокументПервогоБраузера = Элемент.Документ;
		ОкноПервогоБраузера     = ДокументПервогоБраузера.parentWindow; // IE
		Если ОкноПервогоБраузера = Неопределено Тогда
			ОкноПервогоБраузера = ДокументПервогоБраузера.defaultView; // Прочие браузеры
		КонецЕсли;
		ОкноПервогоБраузера.scroll(Элемент.Документ.body.firstChild.nextSibling.clientHeight);
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщение(Команда)
	Если НЕ СокрЛП(ТекстСообщения) = "" Тогда		
		ДобавитьСообщение();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСообщение() Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстОшибки = "Ведение переписки возможно только после записи документа.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ИсторияПереписки.ДобавитьСообщение(Объект.Ссылка, ТекстСообщения);
	ТекстСообщения = "";
	ИсторияПереписки = ПолучитьИсторияПереписки();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИсторияПереписки() Экспорт
	
	МассивСообщений = РегистрыСведений.ИсторияПереписки.ПолучитьМассивСообщений(Объект.Ссылка);
	Возврат РегистрыСведений.ИсторияПереписки.СформироватьИсториюПерепискиHTML(МассивСообщений);	
	
КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ФорматированныйТекст = ТекущийОбъект.СутьЗадачи.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.СутьЗадачи = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриИзменении(Элемент)
	ИсполнителиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИсполнителиПриИзмененииНаСервере()
	Объект.Исполнители.Очистить();
	Для каждого стр из Исполнители Цикл
		Строка = Объект.Исполнители.Добавить();
		Строка.Исполнитель = стр.Значение;
	КонецЦикла;
	СвернутьТабличнуюЧастьНаСервере("Исполнители","Исполнитель");
	ЭтаФорма.Модифицированность = Истина; 	
	ПользовательВИсполнителях();	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриИзменении(Элемент)
	УчастникиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура УчастникиПриИзмененииНаСервере()
	Объект.Участники.Очистить();
	Для каждого стр из Участники Цикл
		Строка = Объект.Участники.Добавить();
		Строка.Участник = стр.Значение;
	КонецЦикла;
	СвернутьТабличнуюЧастьНаСервере("Участники","Участник");
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокПриИзменении(Элемент)
	УстановитьЗаголовокФормы();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	ЭтаФорма.Заголовок = Объект.Заголовок;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьПереписку" Тогда
		ИсторияПереписки = ПолучитьИсторияПереписки();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	УстановитьОтборВУчастниках();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуПодзадачи(Команда)
	НоваяСтрока = Объект.Подзадачи.Добавить(); 
	Элементы.Подзадачи.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор(); 
	Элементы.Подзадачи.ТекущийЭлемент = Элементы.ПодзадачиОписание;
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура СвернутьТабличнуюЧастьНаСервере(ИмяТабличнойЧасти,ИмяСтолбца)
	ТЗ=Объект[ИмяТабличнойЧасти].Выгрузить();
	ТЗ.Свернуть(ИмяСтолбца);
	Объект[ИмяТабличнойЧасти].Загрузить(ТЗ);
КонецПроцедуры

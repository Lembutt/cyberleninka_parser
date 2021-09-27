select *
                from test.fn_pub_add_texts('{"link": "https://cyberleninka.ru/article/n/analiz-tehnologiy-veb-programmirovaniya-dlya-sozdaniya-moduley-vizualizatsii-i-vygruzki-dannyh-informatsionnyh-sistem", "name": "Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем", "authors": "Кузьмин Кирилл Максимович", "info": "способствующие быстрому и качественному созданию модулей графического представления и выгрузки данных информационных систем. Описываются преимущества использования фреймворка языка JavaScript-VueJS в совокупности с библиотеками ChartJS и SheetJS при построении динамических настраиваемых диаграмм, а также автоматическом формировании электронных таблиц. Кроме тоготого, обосновывается целесообразность использования CSS-препроцессоров, а также сборщиков Webpack и NPM при разработке веб-приложений.\r\nКлючевые слова: веб-программирование, JavaScript, front-end, Vue.js, Chart.js, SheetJS/js-xlsx, Webpack, выгрузка данных, модуль визуализации.\r\nВизуализация данных и их выгрузка - один из этапов функционирования большинства", "year": "2019", "source_name": "Вестник Пензенского государственного университета", "source_link": "https://cyberleninka.ru/journal/n/vestnik-penzenskogo-gosudarstvennogo-universiteta", "resource": "cyberleninka", "query": ["javascript", "parser"]}');

select *
                from test.fn_pub_add_texts('{"link": "https://cyberleninka.ru/article/n/issledovanie-metodov-mezhprotsessnogo-vzaimodeystviya-v-informatsionnoy-sisteme-s-gorizontalnym-vzaimodeystviem", "name": "Исследование методов межпроцессного взаимодействия в информационной системе с горизонтальным взаимодействием", "authors": ["Городничев Михаил Геннадьевич", "Кочупалов Александр Евгеньевич"], "info": "программная среда с открытым исходным кодом, которая исполняет JavaScript-код на стороне сервера.\r\nИзначально язык программирования JavaScript был предназначен для написания скриптов для веб-страниц, исполняемых на стороне клиента браузером. Node.js представляет новую парадигму под названием «JavaScript везде», что означает, что JS-код можно использовать ненаписания веб-приложений, работающих по HTTP-протоколу. В фреймворке представлены функции для обработки запросов, составления ответов, обеспечения маршрутизации и др.\r\n2.\tBody Parser. Модуль, использующийся для парсинга содержимого тела запроса в формате j son.\r\n3.\tWebSoket. Модуль, реализуюций протокол WebSocket согласно RFC 6455 [13].\r\n4.\tMongoose. Модуль", "year": "2018", "source_name": "Вестник евразийской науки", "source_link": "https://cyberleninka.ru/journal/n/vestnik-evraziyskoy-nauki", "resource": "cyberleninka", "query": ["javascript", "parser"]}');


select * from test.texts where name = 'Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем';

delete from test.texts where name = 'Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем';

select * from test.texts;
SELECT pg_size_pretty(pg_database_size('texts'));

select * from json_array_elements_text('["foo", "bar"]')
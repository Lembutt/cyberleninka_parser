select *
                from test.fn_pub_add_texts('{"link": "https://cyberleninka.ru/article/n/analiz-tehnologiy-veb-programmirovaniya-dlya-sozdaniya-moduley-vizualizatsii-i-vygruzki-dannyh-informatsionnyh-sistem", "name": "Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем", "authors": "Кузьмин Кирилл Максимович", "info": "способствующие быстрому и качественному созданию модулей графического представления и выгрузки данных информационных систем. Описываются преимущества использования фреймворка языка JavaScript-VueJS в совокупности с библиотеками ChartJS и SheetJS при построении динамических настраиваемых диаграмм, а также автоматическом формировании электронных таблиц. Кроме тоготого, обосновывается целесообразность использования CSS-препроцессоров, а также сборщиков Webpack и NPM при разработке веб-приложений.\r\nКлючевые слова: веб-программирование, JavaScript, front-end, Vue.js, Chart.js, SheetJS/js-xlsx, Webpack, выгрузка данных, модуль визуализации.\r\nВизуализация данных и их выгрузка - один из этапов функционирования большинства", "year": "2019", "source_name": "Вестник Пензенского государственного университета", "source_link": "https://cyberleninka.ru/journal/n/vestnik-penzenskogo-gosudarstvennogo-universiteta", "resource": "cyberleninka", "query": ["javascript", "parser"]}');

select * from test.texts where name = 'Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем';

delete from test.texts where name = 'Анализ технологий веб-программирования для создания модулей визуализации и выгрузки данных информационных систем';

select * from test.texts;

-- check size of db
SELECT pg_size_pretty(pg_database_size('texts'));

SELECT * FROM test.fn_pub_get_counted_data('{"get": true}'::jsonb);
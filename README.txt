Задача:
Сделать корзину интернет магазина на стеке Servlet API + JDBC + JSP(либо SPA на js), DB - любая, при работе с базой не стоит на каждый чих создавать новое соединение, нужно подумать о том как переиспользовать уже созданные соединения, сборщик - maven либо gradle.

Функционал:
1) просмотр списка товаров - наименование и цена, список должен быть заранее создан в базе
2) добавление единицы товара в корзину
3) просмотр корзины
4) удаление позиций из корзины либо добавление единиц уже существующих в ней товаров
5) оформление заказа - набранный в корзине список товаров сохраняется в базе вместе с информацией о клиенте(фио, телефон)

Solution by Java using Servlet API + jdbc + JSP, MySQL database, Maven

Installing&Start
--------------------
1) Unpack the archive where you would like to store the source
2) Create database schemas using dump of the MySQL DB
	command line: mysql -u USER -pPASSWORD jarsoft_test_task < dump.sql

    2.1) Set properties user, pass, url in file src\main\webapp\META-INF\context.xml for you DATABASE
3) Compiled code and package it in WAR format using in directory with pom.xml:
    command line: mvn package
4) Deploy WAR file to web container(servlet container) such as Apache Tomcat

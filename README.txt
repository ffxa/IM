Internet market

Installing&Start
--------------------
1) Unpack the archive where you would like to store the source
2) Create database schemas using dump of the MySQL DB
	command line: mysql -u USER -pPASSWORD jarsoft_test_task < dump.sql

    2.1) Set properties user, pass, url in file src\main\webapp\META-INF\context.xml for you DATABASE
3) Compiled code and package it in WAR format using in directory with pom.xml:
    command line: mvn package
4) Deploy WAR file to web container(servlet container) such as Apache Tomcat
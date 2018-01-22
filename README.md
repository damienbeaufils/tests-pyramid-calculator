# tests-pyramid-calculator

Tests pyramid calculator for Java/Spring application

A french podcast where I talked about test pyramid: http://www.cafe-craft.fr/15


## How to run it

* Update the "where to search" variables
  * WHERE_TO_SEARCH_JAVA_UNIT_TESTS
  * WHERE_TO_SEARCH_JAVA_INT_TESTS
  * WHERE_TO_SEARCH_JS_JASMINE_TESTS
  * WHERE_TO_SEARCH_FUNC_TESTS

* Run it

```
./tests-pyramid-calculator.sh
```

* Example of result

```
Java unit tests count (without @RunWith): 315
Java unit tests count (with @RunWith Mockito, without @Spy): 989
Java integration tests count (with @RunWith Mockito, but with @Spy): 48
Java integration tests count (with @RunWith Spring): 850
Functional tests count: 231
JavaScript tests count (Jasmine spec): 166

Java tests pyramid:
Functional tests: 9%
Integration tests: 36%
Unit tests: 53%
```

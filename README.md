# tests-pyramid-calculator

Tests pyramid calculator for Java/Spring application

A french podcast where I talked about test pyramid: http://www.cafe-craft.fr/15


## How to run it

### Docker image

```
docker run --rm -v $PWD:/code \
-e WHERE_TO_SEARCH_JAVA_UNIT_TESTS=/code/unit-tests \
-e WHERE_TO_SEARCH_JAVA_INT_TESTS=/code/integration-tests \
-e WHERE_TO_SEARCH_JS_JASMINE_TESTS=/code/javascript-tests \
-e WHERE_TO_SEARCH_FUNC_TESTS=/code/functional-tests flopes/tests-pyramid-calculator
```

### Standard way

* Update the "where to search" variables in `tests-pyramid-calculator.sh`
  * WHERE_TO_SEARCH_JAVA_UNIT_TESTS
  * WHERE_TO_SEARCH_JAVA_INT_TESTS
  * WHERE_TO_SEARCH_JS_JASMINE_TESTS
  * WHERE_TO_SEARCH_FUNC_TESTS

* Run it

```
./tests-pyramid-calculator.sh
```

## Example of result

```
Java unit tests count (without @RunWith/@ExtendWith): 315
Java unit tests count (with @RunWith/@ExtendWith Mockito, without @Spy): 989
Java integration tests count (with @RunWith/@ExtendWith Mockito, but with @Spy): 48
Java integration tests count (with @RunWith/@ExtendWith Spring): 850
Functional tests count: 231
JavaScript tests count (Jasmine spec): 166

Java tests pyramid:
Functional tests: 9%
Integration tests: 36%
Unit tests: 53%
```

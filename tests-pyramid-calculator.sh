#!/usr/bin/env bash

readonly WHERE_TO_SEARCH_JAVA_UNIT_TESTS="${WHERE_TO_SEARCH_JAVA_UNIT_TESTS:-/some/directory1 /some/directory2}"
readonly WHERE_TO_SEARCH_JAVA_INT_TESTS="${WHERE_TO_SEARCH_JAVA_INT_TESTS:-/some/directory1 /some/directory2}"
readonly WHERE_TO_SEARCH_JS_JASMINE_TESTS="${WHERE_TO_SEARCH_JS_JASMINE_TESTS-/some/directory1 /some/directory2}"
readonly WHERE_TO_SEARCH_FUNC_TESTS="${WHERE_TO_SEARCH_FUNC_TESTS-/some/directory3}"

# Search all *Test.java files which have no @ExtendWith or @RunWith annotation, and calculate the number of @Test inside => unit tests
readonly JAVA_UNIT_TESTS_PLAIN=$(find $WHERE_TO_SEARCH_JAVA_UNIT_TESTS -name *Test.java -exec grep -L -E "@RunWith|@ExtendWith" {} \; | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @ExtendWith(Mockito... or @RunWith(Mockito... annotation, and no @Spy inside, and calculate the number of @Test inside => unit tests
readonly JAVA_UNIT_TESTS_MOCKITO=$(find $WHERE_TO_SEARCH_JAVA_UNIT_TESTS -name *Test.java -exec grep -E -l "@RunWith\(Mockito|@ExtendWith\(Mockito" {} \; | xargs grep -L "@Spy" | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @ExtendWith(Mockito... or @RunWith(Mockito... annotation, but have @Spy inside, and calculate the number of @Test inside => not really unit tests => integration tests
readonly JAVA_INT_TESTS_MOCKITO=$(find $WHERE_TO_SEARCH_JAVA_INT_TESTS -name *Test.java -exec grep -E -l "@RunWith\(Mockito|@ExtendWith\(Mockito" {} \; | xargs grep -l "@Spy" | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @ExtendWith(Spring... or @RunWith(Spring... annotation, and calculate the number of @Test inside => integration tests
readonly JAVA_INT_TESTS_SPRING=$(find $WHERE_TO_SEARCH_JAVA_INT_TESTS -name *Test.java -exec grep -E -l "@RunWith\(Spring|@ExtendWith\(Spring" {} \; | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files, and calculate the number of tests inside => func tests
readonly JAVA_FUNC_TESTS=$(find $WHERE_TO_SEARCH_FUNC_TESTS -name *Test.java | xargs grep -w "@Test" | wc -l)

# Search all *Spec.js files, and calculate the number of it(...) inside => jasmine tests
readonly JS_JASMINE_TESTS=$(find $WHERE_TO_SEARCH_JS_JASMINE_TESTS -name *Spec.js -exec grep -w "it" {} \; | wc -l)

# Do the math!
readonly JAVA_TOTAL_TESTS=$((JAVA_UNIT_TESTS_MOCKITO+JAVA_INT_TESTS_MOCKITO+JAVA_INT_TESTS_SPRING+JAVA_UNIT_TESTS_PLAIN+JAVA_FUNC_TESTS))

echo "Java unit tests count (without @RunWith/@ExtendWith): $JAVA_UNIT_TESTS_PLAIN"
echo "Java unit tests count (with @RunWith/@ExtendWith Mockito, without @Spy): $JAVA_UNIT_TESTS_MOCKITO"
echo "Java integration tests count (with @RunWith/@ExtendWith Mockito, but with @Spy): $JAVA_INT_TESTS_MOCKITO"
echo "Java integration tests count (with @RunWith/@ExtendWith Spring): $JAVA_INT_TESTS_SPRING"
echo "Functional tests count: $JAVA_FUNC_TESTS"
echo "JavaScript tests count (Jasmine spec): $JS_JASMINE_TESTS"

readonly JAVA_FUNC_MEAN=$((JAVA_FUNC_TESTS*100/JAVA_TOTAL_TESTS))
readonly JAVA_INT_MEAN=$(((JAVA_INT_TESTS_MOCKITO+JAVA_INT_TESTS_SPRING)*100/JAVA_TOTAL_TESTS))
readonly JAVA_UNIT_MEAN=$(((JAVA_UNIT_TESTS_MOCKITO+JAVA_UNIT_TESTS_PLAIN)*100/JAVA_TOTAL_TESTS))

echo ""
echo "Java tests pyramid:"
echo "Functional tests: $JAVA_FUNC_MEAN%"
echo "Integration tests: $JAVA_INT_MEAN%"
echo "Unit tests: $JAVA_UNIT_MEAN%"

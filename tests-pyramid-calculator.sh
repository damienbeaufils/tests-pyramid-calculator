#!/bin/bash

WHERE_TO_SEARCH_JAVA_UNIT_TESTS="/some/directory1 /some/directory2"
WHERE_TO_SEARCH_JAVA_INT_TESTS="/some/directory1 /some/directory2"
WHERE_TO_SEARCH_JS_JASMINE_TESTS="/some/directory1 /some/directory2"
WHERE_TO_SEARCH_FUNC_TESTS="/some/directory3"

# Search all *Test.java files which have no @RunWith annotation, and calculate the number of @Test inside => unit tests
JAVA_UNIT_TESTS_PLAIN=$(find $WHERE_TO_SEARCH_JAVA_UNIT_TESTS -name *Test.java -exec grep -L "@RunWith" {} \; | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @RunWith(Mockito... annotation, and no @Spy inside, and calculate the number of @Test inside => unit tests
JAVA_UNIT_TESTS_MOCKITO=$(find $WHERE_TO_SEARCH_JAVA_UNIT_TESTS -name *Test.java -exec grep -l "@RunWith(Mockito" {} \; | xargs grep -L "@Spy" | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @RunWith(Mockito... annotation, but have @Spy inside, and calculate the number of @Test inside => not really unit tests => integration tests
JAVA_INT_TESTS_MOCKITO=$(find $WHERE_TO_SEARCH_JAVA_INT_TESTS -name *Test.java -exec grep -l "@RunWith(Mockito" {} \; | xargs grep -l "@Spy" | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files which have @RunWith(Spring... annotation, and calculate the number of @Test inside => integration tests
JAVA_INT_TESTS_SPRING=$(find $WHERE_TO_SEARCH_JAVA_INT_TESTS -name *Test.java -exec grep -l "@RunWith(Spring" {} \; | xargs grep -w "@Test" | wc -l)

# Search all *Test.java files, and calculate the number of tests inside => func tests
JAVA_FUNC_TESTS=$(find $WHERE_TO_SEARCH_FUNC_TESTS -name *Test.java | xargs grep -w "@Test" | wc -l)

# Search all *Spec.js files, and calculate the number of it(...) inside => jasmine tests
JS_JASMINE_TESTS=$(find $WHERE_TO_SEARCH_JS_JASMINE_TESTS -name *Spec.js -exec grep -w "it" {} \; | wc -l)

# Do the math!
JAVA_TOTAL_TESTS=$((JAVA_UNIT_TESTS_MOCKITO+JAVA_INT_TESTS_MOCKITO+JAVA_INT_TESTS_SPRING+JAVA_UNIT_TESTS_PLAIN+JAVA_FUNC_TESTS))

echo "Java unit tests count (without @RunWith): $JAVA_UNIT_TESTS_PLAIN"
echo "Java unit tests count (with @RunWith Mockito, without @Spy): $JAVA_UNIT_TESTS_MOCKITO"
echo "Java integration tests count (with @RunWith Mockito, but with @Spy): $JAVA_INT_TESTS_MOCKITO"
echo "Java integration tests count (with @RunWith Spring): $JAVA_INT_TESTS_SPRING"
echo "Functional tests count: $JAVA_FUNC_TESTS"
echo "JavaScript tests count (Jasmine spec): $JS_JASMINE_TESTS"

JAVA_FUNC_MEAN=$((JAVA_FUNC_TESTS*100/JAVA_TOTAL_TESTS))
JAVA_INT_MEAN=$(((JAVA_INT_TESTS_MOCKITO+JAVA_INT_TESTS_SPRING)*100/JAVA_TOTAL_TESTS))
JAVA_UNIT_MEAN=$(((JAVA_UNIT_TESTS_MOCKITO+JAVA_UNIT_TESTS_PLAIN)*100/JAVA_TOTAL_TESTS))

echo ""
echo "Java tests pyramid:"
echo "Functional tests: $JAVA_FUNC_MEAN%"
echo "Integration tests: $JAVA_INT_MEAN%"
echo "Unit tests: $JAVA_UNIT_MEAN%"


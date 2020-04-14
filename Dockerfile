FROM alpine:3.7

LABEL maintainer="Florian Lopes <florianlopes.io>"

RUN apk add --no-cache bash

ENV WHERE_TO_SEARCH_JAVA_UNIT_TESTS ""
ENV WHERE_TO_SEARCH_JAVA_INT_TESTS ""
ENV WHERE_TO_SEARCH_JS_JASMINE_TESTS ""
ENV WHERE_TO_SEARCH_FUNC_TESTS ""

COPY tests-pyramid-calculator.sh /bin

ENTRYPOINT ["tests-pyramid-calculator.sh"]

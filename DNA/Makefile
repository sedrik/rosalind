ERL=erl

.PHONY: test clean

all: test

compile:
	rebar compile

clean:
	rm -f ebin/*.beam

test: compile
	rebar eunit

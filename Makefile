SOURCES := $(wildcard *.asd) $(wildcard core/*.lisp) $(wildcard src/*.lisp)
QL_LOCAL=$(PWD)/.quicklocal/quicklisp
LOCAL_OPTS=--noinform --noprint --disable-debugger --no-sysinit --no-userinit
QL_OPTS=--load $(QL_LOCAL)/setup.lisp

all: factual

deps:
	@sbcl $(LOCAL_OPTS) $(QL_OPTS) \
		--eval '(push "$(PWD)/" asdf:*central-registry*)' \
		--eval '(ql:quickload :factual)' \
		--eval '(quit)'
	@touch $@


factual: $(SOURCES) $(QL_LOCAL)/setup.lisp deps
	@buildapp \
		--asdf-tree $(QL_LOCAL)/local-projects \
		--asdf-tree $(QL_LOCAL)/dists \
		--asdf-path . \
		--load-system factual \
		--eval '(setf *debugger-hook* (lambda (c h) (declare (ignore h)) (format t "~A~%" c) (uiop:quit -1)))' \
		--compress-core \
		--output factual --entry factual.core:main

.PHONY: clean install

clean:
	rm -rf factual deps .quicklocal/

$(QL_LOCAL)/setup.lisp:
	@sbcl --noinform --noprint --disable-debugger --no-sysinit --no-userinit \
		--load quicklisp.lisp \
		--eval '(quicklisp-quickstart:install :path "$(QL_LOCAL)" :dist-url "http://beta.quicklisp.org/dist/quicklisp/2015-08-04/distinfo.txt")' \
		--eval '(quit)'

install:
	install -c -m 755 factual $(DESTDIR)/usr/bin

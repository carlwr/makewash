prefix      ?=  /usr/local
BIN          =  makewash


.PHONY:\
all
all: $(BIN)

.PHONY:\
install
install: $(BIN)
	mkdir -p $(prefix)/bin
	cp $(BIN) $(prefix)/bin/

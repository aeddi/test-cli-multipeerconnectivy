MAKEFILE_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CC=clang
FLAGS=-framework Foundation -framework MultipeerConnectivity
BIN=$(MAKEFILE_DIR)/mpc
FILES=$(MAKEFILE_DIR)/main.m $(MAKEFILE_DIR)/MPCManager.m

build: $(BIN)

host: build
	@$(BIN) host

guest: build
	@$(BIN) guest

$(BIN): $(FILES)
	@$(CC) $(FILES) $(FLAGS) -o $(BIN) && echo "Built: $(BIN)"

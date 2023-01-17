fmt:
	@echo "Formatting code..."
	stylua lua/

test:
	@echo "Running tests..."
	nvim --headless --clean \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory tests {minimal_init = './tests/init.lua'}"

lint:
	@echo "Linting..."
	luacheck .

pr-ready: fmt test lint

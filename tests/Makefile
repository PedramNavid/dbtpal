fmt:
	@echo "Formatting code..."
	stylua --check .

fix:
	@echo "Fixing code..."
	stylua .

test:
	@echo "Running tests..."
	nvim --headless --clean \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory tests {minimal_init = './tests/init.lua'}"

lint:
	@echo "Linting..."
	luacheck ./lua

pr-ready: fmt test lint

fmt:
	@echo "Formatting code..."
	stylua --check .

fix:
	@echo "Fixing code..."
	stylua .

test:
	@echo "Running tests..."
	nvim --headless --noplugin \
	-u tests/minimal.vim \
	-c "PlenaryBustedDirectory tests/ {minimal_init = './tests/minimal.vim'}"

lint:
	@echo "Linting..."
	luacheck ./lua

check: fmt test lint

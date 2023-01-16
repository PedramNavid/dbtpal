test:
	echo "===> Testing:"
	nvim --headless --clean \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory tests {minimal_init = './tests/init.lua'}"

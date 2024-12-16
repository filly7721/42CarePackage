all: cclean valgrind

cclean:
	@echo "Installing CClean..."
	@cd ./Cleaner_42; yes | sh ./CleanerInstaller.sh 1>/dev/null && echo "Installed Successfully."

valgrind:
	@echo "Installing Valgrind..."
	@cd 42-ValgrindContainer; yes | sh ./install 1>/dev/null; sh ./build 1>/dev/null && echo "Installed Successfully."

.PHONY:	all cclean valgrind

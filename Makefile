all: cclean valgrind

cclean:
	@echo "Installing CClean"
	@sh ./Cleaner_42/CleanerInstaller.sh

valgrind:
	@echo "Installing Valgrind"
	@sh ./42-ValgrindContainer/install

.PHONY:	all cclean valgrind

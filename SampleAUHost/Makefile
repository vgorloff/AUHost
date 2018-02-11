default:
	@echo "Available actions:"
	@cat Makefile | grep ":$$" | sed 's/://' | xargs -I{} echo " - make {}"

verify:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.verify"
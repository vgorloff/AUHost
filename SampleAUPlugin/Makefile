default:
	@echo "Available actions:"
	@cat Makefile | grep ":$$" | sed 's/://' | xargs -I{} echo " - make {}"

post:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.post"

verify:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.verify"


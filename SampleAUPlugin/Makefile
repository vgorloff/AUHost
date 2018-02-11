default:
	@echo "Available actions:"
	@cat Makefile | grep ":$$" | sed 's/://' | xargs -I{} echo " - make {}"

ci:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.ci"

build:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.build"

clean:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.clean"

post:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.post"

release:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.release"

verify:
	@ruby -r "`pwd`/Automation.rb" -e "Automation.verify"


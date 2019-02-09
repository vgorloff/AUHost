.PHONY: default ci build clean test release verify deploy


default:
	@echo "Available actions:"
	@cat Makefile | grep ":$$" | sed 's/://' | xargs -I{} echo " - make {}"

ci:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").ci"

build:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").build"

clean:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").clean"

test:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").test"

release:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").release"

verify:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").verify"

deploy:
	@ruby -r "`pwd`/Project.rb" -e "Project.new(\"`pwd`\").deploy"

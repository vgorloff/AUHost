default:
	@node -e "$$=require('wl-scripting'); $$.AbstractProject.perform('`pwd`/Project.js', 'list')"

# See why we need this: https://stackoverflow.com/a/6273809/1418981
%:
	@node -e "$$=require('wl-scripting'); $$.AbstractProject.perform('`pwd`/Project.js', '$@')"


USER_NAME = $(shell python3 Scripts/author_name.py)
CURRENT_DATE = $(shell pipenv run python Scripts/current_date.py)


Feature:
	@mkdir -p Projects/Feature/${name};
	@tuist scaffold Feature \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit

Domain:
	@mkdir -p Projects/Domain/${name};
	@tuist scaffold DefaultModule \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)" \
	--layer "Domain";
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit
	
Data:
	@mkdir -p Projects/Data/${name};
	@tuist scaffold DefaultModule \
	--name ${name} \
	--layer "Data" \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit

Shared:
	@mkdir -p Projects/Shared/${name};
	@tuist scaffold DefaultModule \
	--name ${name} \
	--layer "Shared" \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit

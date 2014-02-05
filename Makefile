all: bootstrap build_public_folder

bootstrap:
	@echo "Downloading bootstrap using bower"
	@bower install bootstrap
	@echo "Downloading select2 using bower"
	@bower install select2
	@echo "\n"

build_public_folder:
	@if [ -a public/js ];  then echo "Creating public javascript folder"; mkdir -p public/js;  fi;
	@if [ -a public/css ]; then echo "Creating public stylesheet folder"; mkdir -p public/css; fi;
	@echo "Copying jquery into public javascript folder"
	@cp -fv bower_components/jquery/jquery.min.js public/js/
	@echo "Copying bootstrap into public javascript folder"
	@cp -rfv bower_components/bootstrap/dist/* public/
	@cp -fv bower_components/bootstrap/js/* public/js
	@echo "Copying select2 into public javascript folder"
	@cp -fv bower_components/select2/select2.min.js public/js/
	@echo "Copying select2 into public stylesheet folder"
	@cp -fv bower_components/select2/select2.css public/css/



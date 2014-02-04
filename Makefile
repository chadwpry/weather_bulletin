all: bootstrap build_public_folder

bootstrap:
	@echo "Downloading bootstrap using bower"
	@bower install bootstrap
	@echo "\n"

build_public_folder:
	@if [ -a public/js ];  then echo "Creating public javascript folder"; mkdir -p public/js;  fi;
	@if [ -a public/css ]; then echo "Creating public stylesheet folder"; mkdir -p public/css; fi;
	@echo "\n"
	@echo "Copying jquery into public javascript folder"
	@cp -fv bower_components/jquery/jquery.min.js public/js/
	@echo "\n"
	@echo "Copying bootstrap into public javascript folder"
	@cp -rfv bower_components/bootstrap/dist/* public/
	@cp -fv bower_components/bootstrap/js/* public/js



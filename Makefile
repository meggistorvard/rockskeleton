ROCKSKELETON = ./docs/assets/css/rockskeleton.css
ROCKSKELETON_LESS = ./less/rockskeleton.less
ROCKSKELETON_RESPONSIVE = ./docs/assets/css/rockskeleton-responsive.css
ROCKSKELETON_RESPONSIVE_LESS = ./less/responsive.less
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


#
# BUILD DOCS
#

build:
	@echo "\n${HR}"
	@echo "Building Rockskeleton..."
	@echo "${HR}\n"
	@./node_modules/.bin/jshint js/*.js --config js/.jshintrc
	@./node_modules/.bin/jshint js/tests/unit/*.js --config js/.jshintrc
	@echo "Running JSHint on javascript...             ${CHECK} Done"
	@./node_modules/.bin/recess --compile ${ROCKSKELETON_LESS} > ${ROCKSKELETON}
	@./node_modules/.bin/recess --compile ${ROCKSKELETON_RESPONSIVE_LESS} > ${ROCKSKELETON_RESPONSIVE}
	@echo "Compiling LESS with Recess...               ${CHECK} Done"
	@node docs/build
	@cp img/* docs/assets/img/
	@cp js/*.js docs/assets/js/
	@cp js/tests/vendor/jquery.js docs/assets/js/
	@echo "Compiling documentation...                  ${CHECK} Done"
	@cat js/rockskeleton-transition.js js/rockskeleton-alert.js js/rockskeleton-button.js js/rockskeleton-carousel.js js/rockskeleton-collapse.js js/rockskeleton-dropdown.js js/rockskeleton-modal.js js/rockskeleton-tooltip.js js/rockskeleton-popover.js js/rockskeleton-scrollspy.js js/rockskeleton-tab.js js/rockskeleton-typeahead.js js/rockskeleton-affix.js > docs/assets/js/rockskeleton.js
	@./node_modules/.bin/uglifyjs -nc docs/assets/js/rockskeleton.js > docs/assets/js/rockskeleton.min.tmp.js
	@echo "/**\n* Rockskeleton.js by @fat & @mdo\n* Copyright 2020 Meggis.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > docs/assets/js/copyright.js
	@cat docs/assets/js/copyright.js docs/assets/js/rockskeleton.min.tmp.js > docs/assets/js/rockskeleton.min.js
	@rm docs/assets/js/copyright.js docs/assets/js/rockskeleton.min.tmp.js
	@echo "Compiling and minifying javascript...       ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Rockskeleton successfully built at ${DATE}."
	@echo "${HR}\n"
	@echo "Thanks for using Rockskeleton,"
	@echo "<3 @mdo and @fat\n"

#
# RUN JSHINT & QUNIT TESTS IN PHANTOMJS
#

test:
	./node_modules/.bin/jshint js/*.js --config js/.jshintrc
	./node_modules/.bin/jshint js/tests/unit/*.js --config js/.jshintrc
	node js/tests/server.js &
	phantomjs js/tests/phantom.js "http://localhost:3000/js/tests"
	kill -9 `cat js/tests/pid.txt`
	rm js/tests/pid.txt

#
# CLEANS THE ROOT DIRECTORY OF PRIOR BUILDS
#

clean:
	rm -r rockskeleton

#
# BUILD SIMPLE ROCKSKELETON DIRECTORY
# recess & uglifyjs are required
#

rockskeleton: rockskeleton-img rockskeleton-css rockskeleton-js


#
# JS COMPILE
#
rockskeleton-js: rockskeleton/js/*.js

rockskeleton/js/*.js: js/*.js
	mkdir -p rockskeleton/js
	cat js/rockskeleton-transition.js js/rockskeleton-alert.js js/rockskeleton-button.js js/rockskeleton-carousel.js js/rockskeleton-collapse.js js/rockskeleton-dropdown.js js/rockskeleton-modal.js js/rockskeleton-tooltip.js js/rockskeleton-popover.js js/rockskeleton-scrollspy.js js/rockskeleton-tab.js js/rockskeleton-typeahead.js js/rockskeleton-affix.js > rockskeleton/js/rockskeleton.js
	./node_modules/.bin/uglifyjs -nc rockskeleton/js/rockskeleton.js > rockskeleton/js/rockskeleton.min.tmp.js
	echo "/*!\n* Rockskeleton.js by @fat & @mdo\n* Copyright 2020 Meggis.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > rockskeleton/js/copyright.js
	cat rockskeleton/js/copyright.js rockskeleton/js/rockskeleton.min.tmp.js > rockskeleton/js/rockskeleton.min.js
	rm rockskeleton/js/copyright.js rockskeleton/js/rockskeleton.min.tmp.js

#
# CSS COMPLILE
#

rockskeleton-css: rockskeleton/css/*.css

rockskeleton/css/*.css: less/*.less
	mkdir -p rockskeleton/css
	./node_modules/.bin/recess --compile ${ROCKSKELETON_LESS} > rockskeleton/css/rockskeleton.css
	./node_modules/.bin/recess --compress ${ROCKSKELETON_LESS} > rockskeleton/css/rockskeleton.min.css
	./node_modules/.bin/recess --compile ${ROCKSKELETON_RESPONSIVE_LESS} > rockskeleton/css/rockskeleton-responsive.css
	./node_modules/.bin/recess --compress ${ROCKSKELETON_RESPONSIVE_LESS} > rockskeleton/css/rockskeleton-responsive.min.css

#
# IMAGES
#

rockskeleton-img: rockskeleton/img/*

rockskeleton/img/*: img/*
	mkdir -p rockskeleton/img
	cp img/* rockskeleton/img/


#
# MAKE FOR GH-PAGES 4 FAT & MDO ONLY (O_O  )
#

gh-pages: rockskeleton docs
	rm -f docs/assets/rockskeleton.zip
	zip -r docs/assets/rockskeleton.zip rockskeleton
	rm -r rockskeleton
	rm -f ../rockskeleton-gh-pages/assets/rockskeleton.zip
	node docs/build production
	cp -r docs/* ../rockskeleton-gh-pages

#
# WATCH LESS FILES
#

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: docs watch gh-pages rockskeleton-img rockskeleton-css rockskeleton-js
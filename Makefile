ROCKSKELETON = ./docs/assets/css/rockskeleton.css
ROCKSKELETON_LESS = ./less/rockskeleton.less
ROCKSKELETON_RESPONSIVE = ./docs/assets/css/rockskeleton.responsive.css
ROCKSKELETON_RESPONSIVE_LESS = ./less/responsive.less
LESS_COMPRESSOR ?= `which lessc`
WATCHR ?= `which watchr`

#
# BUILD DOCS
#

docs: rockskeleton
	zip -r docs/assets/rockskeleton.zip rockskeleton
	rm -r rockskeleton
	lessc ${ROCKSKELETON_LESS} > ${ROCKSKELETON}
	lessc ${ROCKSKELETON_RESPONSIVE_LESS} > ${ROCKSKELETON_RESPONSIVE}
	node docs/build
	cp img/* docs/assets/img/
	cp js/*.js docs/assets/js/
	cp js/tests/vendor/jquery.js docs/assets/js/
	cp js/tests/vendor/jquery.js docs/assets/js/

#
# BUILD SIMPLE ROCKSKELETON DIRECTORY
# lessc & uglifyjs are required
#

rockskeleton:
	mkdir -p rockskeleton/img
	mkdir -p rockskeleton/css
	mkdir -p rockskeleton/js
	cp img/* rockskeleton/img/
	lessc ${ROCKSKELETON_LESS} > rockskeleton/css/rockskeleton.css
	lessc --compress ${ROCKSKELETON_LESS} > rockskeleton/css/rockskeleton.min.css
	lessc ${ROCKSKELETON_RESPONSIVE_LESS} > rockskeleton/css/rockskeleton.responsive
	lessc --compress ${ROCKSKELETON_RESPONSIVE_LESS} > rockskeleton/css/rockskeleton.min.responsive
	cat js/rockskeleton-transition.js js/rockskeleton-alert.js js/rockskeleton-button.js js/rockskeleton-carousel.js js/rockskeleton-collapse.js js/rockskeleton-dropdown.js js/rockskeleton-modal.js js/rockskeleton-tooltip.js js/rockskeleton-popover.js js/rockskeleton-scrollspy.js js/rockskeleton-tab.js js/rockskeleton-typeahead.js > rockskeleton/js/rockskeleton.js
	uglifyjs -nc rockskeleton/js/rockskeleton.js > rockskeleton/js/rockskeleton.min.js

#
# WATCH LESS FILES
#

gh-pages:
	cp -r docs/* ../rockskeleton-gh-pages

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: dist docs watch gh-pages

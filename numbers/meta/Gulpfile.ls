gulp = require "gulp"
livescript = require "gulp-livescript"
mocha = require "gulp-mocha"


_base = ".."
_src = "#{_base}/src/**/*.ls"
_pub = "#{_base}/build"
_test = "#{_base}/tests/**/*.ls"


gulp.task "build", ->
	gulp.src _src
		.pipe livescript!on "error", -> throw new Error it
		.pipe gulp.dest _pub

gulp.task "test", ->
	gulp.src _test
		.pipe mocha reporter: 'min', ui: 'bdd'
gulp = require "gulp"
livescript = require "gulp-livescript"
del = require "del"

clean = -> del.sync "../build", force: true

build = -> gulp.src "../src/**/*.ls" .pipe livescript! .pipe gulp.dest("../build")


gulp.task "clean", clean

gulp.task "build", build

gulp.task "rebuild", ["clean"], build

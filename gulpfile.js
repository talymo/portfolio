var bower, bowery, coffee, connect, gulp, image, jade, plumber, print, sass, wiredep;

gulp = require('gulp');

plumber = require('gulp-plumber');

bower = require('bower');

jade = require('gulp-jade');

connect = require('gulp-connect');

sass = require('gulp-sass');

bowery = require('main-bower-files');

print = require('gulp-print');

wiredep = require('wiredep');

image = require('gulp-image-optimization');

gulp.task('build', function() {
    return bower.commands.install([], {
        save: true
    }, {});
});

gulp.task('bowered', ['build'], function() {
    gulp.src('./build/markup/partials/_head.jade').pipe(wiredep.stream({
        fileTypes: {
            jade: {
                replace: {
                    js: function(path) {
                        return 'script(src="vendor/' + path.split('/').slice(4, path.split('/').length).join('/') + '")';
                    }
                }
            }
        }
    })).pipe(gulp.dest('./build/markup/partials'));
    return gulp.src(bowery(), {
        base: './bower_components'
    }).pipe(gulp.dest('./deploy/vendor'));
});

gulp.task('markup', ['bowered'], function() {
    return gulp.src(["./build/markup/**/*.jade", "!./build/markup/partials/*.jade"]).pipe(plumber()).pipe(jade({
        pretty: true
    })).pipe(gulp.dest('./deploy')).pipe(connect.reload());
});

gulp.task('styles', ['bowered'], function() {
    return gulp.src('./build/styles/*.scss').pipe(plumber()).pipe(sass()).pipe(gulp.dest('./deploy/styles')).pipe(connect.reload());
});

gulp.task('images', ['bowered'], function() {
    return gulp.src('./build/images/*').pipe(plumber()).pipe(image()).pipe(gulp.dest('./deploy/images')).pipe(connect.reload());
});

gulp.task('scripts', ['bowered'], function() {
    return gulp.src('./build/scripts/**/*.js').pipe(plumber()).pipe(gulp.dest('./deploy/scripts')).pipe(connect.reload());
});

gulp.task('watch', function() {
    gulp.watch('./build/markup/**/*.jade', ['markup']);
    gulp.watch('./build/styles/**/*.scss', ['styles']);
    gulp.watch('./build/images/**/', ['images']);
    return gulp.watch('./build/scripts/**/*.js', ['scripts']);
});

gulp.task('server', function() {
    return connect.server({
        port: 8181,
        livereload: true,
        root: 'deploy'
    });
});

gulp.task('default', ['build', 'bowered', 'package', 'server', 'watch']);

gulp.task('package', ['markup', 'styles', 'images', 'scripts']);

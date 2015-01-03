gulp = require 'gulp'
plumber = require 'gulp-plumber'
bower = require 'bower'
jade = require 'gulp-jade'
connect = require 'gulp-connect'
sass = require 'gulp-sass'
bowery = require 'main-bower-files'
print = require 'gulp-print'
wiredep = require 'wiredep'
image = require 'gulp-image'
coffee = require 'gulp-coffee'

#install all bower dependencies and then move them over to the deploy folder
gulp.task 'build', ->

	return bower.commands.install([],
		save: true
	, {})


#bower dependencies
gulp.task 'bowered', ['build'], ->
	# Wire up bower dependencies in _head.jade
	gulp.src './build/markup/partials/_head.jade'
		.pipe wiredep.stream
			fileTypes:
				jade:
					replace:
						js: (path) -> 'script(src="vendor/'+ path.split('/').slice(4, path.split('/').length).join('/')+'")'
		.pipe gulp.dest './build/markup/partials'

	gulp.src bowery(), base: './bower_components'
		.pipe gulp.dest './deploy/vendor'


# build out the jade files
gulp.task 'markup', ['bowered'], ->
	gulp.src [
		"./build/markup/**/*.jade"
		"!./build/markup/partials/*.jade"
	]
		.pipe plumber()
		.pipe jade({pretty: true})
		.pipe gulp.dest './deploy'
		.pipe connect.reload()

#build out the style files
gulp.task 'styles', ['bowered'], ->
	gulp.src './build/styles/*.scss'
		.pipe plumber()
		.pipe sass()
		.pipe gulp.dest './deploy/styles'
		.pipe connect.reload()

#optimize and deploy the images
gulp.task 'images', ['bowered'], ->
	gulp.src './build/images/*'
		.pipe plumber()
		.pipe image()
		.pipe gulp.dest './deploy/images'
		.pipe connect.reload()

#build out the coffee files
gulp.task 'scripts', ['bowered'], ->
	gulp.src './build/scripts/**/*.coffee'
		.pipe plumber()
		.pipe coffee()
		.pipe gulp.dest './deploy/scripts'
		.pipe connect.reload()

#set up a watch so we can monitor changes to these files.
gulp.task 'watch', ->
	gulp.watch './build/markup/**/*.jade', ['markup']
	gulp.watch './build/styles/**/*.scss', ['styles']
	gulp.watch './build/images/**/', ['images']
	gulp.watch './build/scripts/**/*.coffee', ['scripts']

#set up a server so we can view this awesome stuff
gulp.task 'server', ->
	connect.server
		port: 8181
		livereload: true
		root: 'deploy'

gulp.task 'default', ['build', 'bowered', 'package', 'server', 'watch']

gulp.task 'package', ['markup','styles','images','scripts']

Instructions:

1. Make a directory on your computer named giggle 
2. Clone git repository into your folder "https://github.com/talymo/giggle.git"
3. npm install - this might take a minute because for some reason gulp-image likes to take it's sweet time. Be patient.
4. gulp - once you run gulp, you will see a bunch of messages in your console. If you don't see any images just yet, hold tight. Image compression takes a minute.
5. Open http://localhost:8181 in your browser and relish in the awesomeness that I have created.

Adding New Bower Packages
  1. go to your git bash and type in bower install --save-dev &lt;package-name&gt;
  2. you will have to ctrl-c out of the server so that you can install the bower dependency and have it integrated into the new build system.
  3. once you are done, run gulp again
  
Adding New Node Packages
  1. go to your git bash and type in npm install --save-dev &lt;package-name&gt;
  2. if you need a gulp task to convert these files or do anything else to them, you will have to follow the package documentation on setting that up.
  
Adding New Jade, Sass, Coffee and images
  1. Always add these files in the build section of the project. 
  
Tips:
  - If you add new bower or node packages, or if you delete existing ones, go ahead and delete the deploy folder. It will reappear on build. When you delete the deploy folder it will remove all instances of old code that the build process could be hanging on to. I plan on implementing an automatic delete task in the future so until that is done, this will help you keep things fresh.
  - If you are adding new gulp tasks and something just isn't working, make sure you take a look at the code around you in the file and see how the tasks relate to one another. The markup, styles, scripts and images file depend on the bowered task to be done before they start, so keep that in mind when adding more tasks to the project. 
  
LiveReload
  LiveReload will watch changes in your images folder, markup folder, styles folder and scripts folder. When it detects changes it will reload the browser for you. For the markup, styles, and scripts folder, this will happen on save. 

I will be adding more features in the future as I see fit. If you see something that I am doing that is completely stupid or could be done better, let me know! 

Thanks and I hope this helps you with your website projects. :)

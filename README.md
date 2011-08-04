camera-server
=============

[camera/uploader.rb] ----(upload JPEG)----> [camera-server.rb] <----(reload)----> [browser/camera-server.js]


Dependencies
------------

* Ruby 1.8.7
* jQuery

Install Dependencies

    % gem install ArgsParser eventmachine eventmachine_httpserver



Run Server
----------

    % ruby camera-server.rb -help
    % ruby camera-server.rb -port 8785

=> port 8785



Run uploader
------------

    % ruby uplaoder.rb --help
    % ruby uploader.rb -u http://localhost:8785/camera_1 -f camera/camera.jpg -i 1 -l



Display camera image
--------------------

start camera-server.js

head

    <script src='jquery.js' type='text/javascript' />
    <script src='camera-server.js' type='text/javascript' />
    <script type='text/javascript'>
        $(function(){
          CameraServer.start($('div#camera_img'), 'http://localhost:8785/camera_1', 1000);
        });
    </script>


body

    <div id='camera_img'></div>

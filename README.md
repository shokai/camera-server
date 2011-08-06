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

upload "camera_1"

    % ruby uplaoder.rb --help
    % ruby uploader.rb -u http://localhost:8785/camera_1 -f camera/camera.jpg -interval 1 -loop



Display camera image
--------------------

start camera-server.js to display "camera_1"

head

    <script src='jquery.js' type='text/javascript' />
    <script src='camera-server.js' type='text/javascript' />
    <script type='text/javascript'>
        $(function(){
          new CameraServer().start($('div#camera_img'), 'http://localhost:8785/camera_1', 1000);
        });
    </script>


body

    <div id='camera_img'></div>


see "viewer/simple/index.html"


Get Camera List
---------------

get camera and binary size list.

json format

    % curl http://localhost:8785/index.json

    [{"path":"/camera_1","size":8016},{"path":"/camera_2","size":7068}]



jsonp callback

    % curl "http://localhost:8785/index.json?jsoncallback=my_callback"

    my_callback([{"path":"/camera_1","size":8016},{"path":"/camera_2","size":7068}]);


see "viewer/multiview/index.html"
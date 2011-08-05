$(function(){
    check_camera();
    setInterval(check_camera, 10000);
});

var check_camera = function(){
    $.get(index+'?jsoncallback=?', {}, function(e){
        for(var i = 0; i < e.length ; i++){
            var id = e[i].path.replace('/','_');
            var url = server + e[i].path;
            if($('div#cameras #'+id).length < 1){
                $('<div>').attr('id', id).addClass("camera").appendTo('div#cameras');
                new CameraServer().start($('div#cameras #'+id), url, 1000);
            }
        }
    }, 'jsonp');
};

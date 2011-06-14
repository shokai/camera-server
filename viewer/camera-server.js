var CameraServer = {};

CameraServer.init = function(display_obj){
    display_obj.append($('<span>').attr('id','view'));
    display_obj.append($('<span>').attr('id','tmp').css('visibility','hidden'));
};

CameraServer.do_reload = function(display_obj, img_url, delay_msec){
    var img = $('<img>').attr('src',img_url+'?'+new Date().getTime());
    var load_err_timer = setTimeout(function(){
        CameraServer.do_reload(display_obj, img_url, delay_msec);
    }, 10000)
    img.load(function(){
        clearTimeout(load_err_timer);
        display_obj.children('#view').html(img);
        setTimeout(function(){
            CameraServer.do_reload(display_obj, img_url, delay_msec);
        }, delay_msec);
    });
    display_obj.children('#tmp').html(img);
};

CameraServer.start = function(display_obj, img_url, delay_msec){
    CameraServer.init(display_obj);
    CameraServer.do_reload(display_obj, img_url, delay_msec);
};

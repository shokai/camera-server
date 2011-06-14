var CameraServer = {};
CameraServer.count = 0;

CameraServer.init = function(display_obj){
    display_obj.append($('<span>').attr('id','0').hide());
    display_obj.append($('<span>').attr('id','1').hide());
};

CameraServer.do_reload = function(display_obj, img_url, delay_msec){
    var img = $('<img>').attr('src',img_url+'?'+new Date().getTime());
    var id = CameraServer.count++ % 2;
    var load_err_timer = setTimeout(function(){
        CameraServer.do_reload(display_obj, img_url, delay_msec);
    }, 10000)
    img.load(function(){
        clearTimeout(load_err_timer);
        display_obj.children('#'+id).show();
        if(id == 0) id2 = 1;
        else id2 = 0;
        display_obj.children('#'+id2).hide();
        setTimeout(function(){
            CameraServer.do_reload(display_obj, img_url, delay_msec);
        }, delay_msec);
    });
    display_obj.children('#'+id).html(img);
};

CameraServer.start = function(display_obj, img_url, delay_msec){
    CameraServer.init(display_obj);
    CameraServer.do_reload(display_obj, img_url, delay_msec);
};

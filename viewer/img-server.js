var ImgServer = {};

ImgServer.init = function(display_obj){
    display_obj.append($('<span>').attr('id','view'));
    display_obj.append($('<span>').attr('id','tmp').css('visibility','hidden'));
};

ImgServer.do_reload = function(display_obj, img_url, delay_msec){
    var img = $('<img>').attr('src',img_url+'?'+new Date().getTime());
    var load_err_timer = setTimeout(function(){
        console.log('load_err_timer');
        ImgServer.do_reload(display_obj, img_url, delay_msec);
    }, 10000)
    img.load(function(){
        clearTimeout(load_err_timer);
        display_obj.children('#view').html(img);
        setTimeout(function(){
            ImgServer.do_reload(display_obj, img_url, delay_msec);
        }, delay_msec);
    });
    display_obj.children('#tmp').html(img);
};

ImgServer.start = function(display_obj, img_url, delay_msec){
    ImgServer.init(display_obj);
    ImgServer.do_reload(display_obj, img_url, delay_msec);
};

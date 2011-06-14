var ImgServer = {};
ImgServer.start = function(display_obj, img_url, delay_msec){
    var img = $('<img>').attr('src',img_url+'?'+new Date().getTime());
    var load_err_timer = setTimeout(function(){
        console.log('load_err_timer');
        ImgServer.start(display_obj, img_url, delay_msec);
    }, 10000)
    img.load(function(){
        clearTimeout(load_err_timer);
        display_obj.children('#view').html(img);
        setTimeout(function(){
            ImgServer.start(display_obj, img_url, delay_msec);
        }, delay_msec);
    });
    display_obj.children('#tmp').css('visibility','hidden').html(img);
};

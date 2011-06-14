var ImgServer = {};
ImgServer.start = function(obj, url, delay_msec){
    var img = $('<img>').attr('src',url+'?'+new Date().getTime());
    img.load(function(){
        obj.children('#view').html(img);
        setTimeout(function(){
            ImgServer.start(obj, url, delay_msec);
        }, delay_msec);
    });
    obj.children('#tmp').css('visibility','hidden').html(img);
};

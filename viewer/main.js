
$(function(){
    $('#camera_img #tmp').css('visibility','hidden');
    camera_img_start($('div#camera_img'), 'http://localhost:8080');
});

function camera_img_start(obj, url){
    var img = $('<img>')
        .attr('src',url+'?'+new Date().getTime())
        .load(function(){
            $('#camera_img #view').html(img);
            setTimeout(function(){
                camera_img_start(obj,url + '?' + new Date().getTime());
                
            },500);
        });
    $('#camera_img #tmp').html(img);
};
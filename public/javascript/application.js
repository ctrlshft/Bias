

$(document).ready(function() {
  $('.tooltip').tooltipster({
    animation: 'fade',
    delay: 20,
    theme: 'tooltipster-noir',
    touchDevices: false,
    trigger: 'hover'
  });

  // $(".article_dot").on('click', function(){
  //    var url = $(this).data().url
  //    window.open(url, '_blank');   
  // });


  


  $(".article_dot").on('click', function(){
    var url = $(this).data().url;
    var content = $(this).data().content;
    var score = $(this).data().score;
    var title = $(this).data().title;

    if (score < -0.1) { 
      // $("#negative-article").empty().append("<p> <a href=" + url + "/a>" + Go to full article + "</p>"); 
      $("#negative-article").css('visibility', 'visible');
      $("#negative-article").empty().append("<p> <a target='_blank' href=" + url + "/a>" + title + "</p>"); 
      $("#negative-article").append("<p>" + content + "</p>"); 
    }
    else {
      $("#positive-article").css('visibility', 'visible');
      $("#positive-article").empty().append("<p> <a target='_blank' href=" + url + "/a>" + title + "</p>"); 
      $("#positive-article").append("<p>" + content + "</p>"); 
    }
  });




  // $(".sentiment_scale").on('hover', function(){

  //    $("#sentiment_scale div").css("left":35);
 
  // });

  
});
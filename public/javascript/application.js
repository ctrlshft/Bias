

$(document).ready(function() {
  $('.tooltip').tooltipster({
    animation: 'fade',
    delay: 20,
    theme: 'tooltipster-noir',
    touchDevices: false,
    trigger: 'hover'
  });

  setTimeout(function(){
    // $("div#1.article_dot.tooltip.tooltipstered").trigger('click'); 
    $("div.article_dot:first-child").trigger('click'); 
    $("div.article_dot:last-child").trigger('click'); 
  }, 300);

  $("#sentiment_scale").click(function() {
    if (!$(this).hasClass("relative")) {
      $(this).addClass("relative")
      $( ".article_dot" ).each(function( index, element ) {
        var score_relative = $(element).data().srel
        $( element ).css( "left", score_relative + "%");
      });
    }

    else {
      $(this).removeClass("relative")
      $( ".article_dot" ).each(function( index, element ) {
        var score_absolute = $(element).data().sabs
        $( element ).css( "left", score_absolute + "%");
      });
    }
  });

  $('#title').removeClass('rotate');
  
  $('#submit_button').on('click', function(){
    $('#title').addClass('rotate');
  });





  $(".article_dot").on('click', function(event){
    event.stopPropagation();
    var url = $(this).data().url;
    var content = $(this).data().content;
    var score = $(this).data().srel;
    var title = $(this).data().title;

    if (score < 50) { 
      // $("#negative-article").empty().append("<p> <a href=" + url + "/a>" + Go to full article + "</p>"); 
      
      $("#negative-article").css('visibility','visible');
      $("#negative-article").css('border-color', 'hsl(' + score + ',30%, 50%)'); 
      $("#negative-article").empty().append("<p> <a target='_blank' href=" + url + "/a>" + title + "</p>"); 
      $("#negative-article").append("<p>" + content + "</p>"); 
    

    }
    else {
      
      $("#positive-article").css('visibility','visible');
      $("#positive-article").css('border-color', 'hsl(' + score + ',30%, 50%)'); 
      $("#positive-article").empty().append("<p> <a target='_blank' href=" + url + "/a>" + title + "</p>"); 
      $("#positive-article").append("<p>" + content + "</p>"); 

    }
  });




  // $(".sentiment_scale").on('hover', function(){

  //    $("#sentiment_scale div").css("left":35);
 
  // });

  
});
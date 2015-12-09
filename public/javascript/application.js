

$(document).ready(function() {
  $('.tooltip').tooltipster({
    animation: 'fade',
    delay: 20,
    theme: 'tooltipster-noir',
    touchDevices: false,
    trigger: 'hover'
  });

  $(".article_dot").on('click', function(){
     var url = $(this).data().url
     window.open(url, '_blank');   
  });

  
});
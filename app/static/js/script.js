$('document').ready(function() {
  $('.new-markov').on('click', function() {
    var newbtn = $(this);
    var userName = newbtn.data('username');
    $.ajax({
      data: {'user_name': userName},
      url: '/get_markov',
      type: 'POST', 
      success: function(chain) {
        newbtn.siblings('.chain').text(chain);
      },
      error: function(e) {
        console.log(e);
      }
    });
  });
});

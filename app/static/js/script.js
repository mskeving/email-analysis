$('document').ready(function() {
  $('.new-btn').on('click', function() {
    var newbtn = $(this);
    var userName = newbtn.data('username');
    $.ajax({
      data: {'user_name': userName},
      url: '/get_markov',
      type: 'POST', 
      success: function(chain) {
        $('.chain[data-username=' + userName + ']').text(chain);
      },
      error: function(e) {
        console.log(e);
      }
    });
  });
});

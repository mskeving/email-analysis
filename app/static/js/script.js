console.log('in js');

$('document').ready(function() {
  $('#missy-new-markov').on('click', function() {
    $.ajax({
      data: {'user_name': 'missy'},
      url: '/get_markov',
      type: 'POST', 
      success: function(chain) {
        $('.chain').text(chain);
      },
      error: function(e) {
        console.log(e);
      }
    });
  });
});

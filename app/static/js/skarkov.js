require("../css/styles.css")
$ = require("jquery")

$('document').ready(function() {
  $('.btn.tweet').on('click', function(e) {
    var markov_id = $(this).data('markov-id');
    var userName = $(this).data('username');
    var chain = $('.chain[data-username=' + userName + ']').text();
    $.ajax({
      data: {'markov_id': markov_id},
      url: '/tweet',
      type: 'POST',
      success: function() {
        var win = window.open('http://twitter.com/home?status="' + chain + '" - ', '_blank');
        if (win) {
          //Browser has allowed it to be opened
          win.focus();
        } else {
          alert("Please allow pop-ups.");
        }
      },
      error: function(e) {
        alert("Error tweeting!");
      }
    });
  });
  $('.btn.new').on('click', function() {
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

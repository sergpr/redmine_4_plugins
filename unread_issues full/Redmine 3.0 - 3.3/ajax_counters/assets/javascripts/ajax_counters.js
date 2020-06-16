RMPlus.AC = (function(my){
  var my = my || {};

  my.expired_ajax_counters = [];

  my.refresh_ajax_counters = function() {
    if (my.expired_ajax_counters && my.expired_ajax_counters.length > 0) {
      $.ajax({ url: RMPlus.Utils.relative_url_root + '/ajax_counters/counters',
               type: 'post',
               dataType: 'json',
               data: { counters: my.expired_ajax_counters }
      }).done(function(data) {
        if (data) {
          for (var key in data) {
            my.draw_counter(key, data[key]);
          }
        }
      }).always(function() {
        $(document.body).trigger('ac:refresh_complete');
      });

      my.expired_ajax_counters = [];
    } else {
      $(document.body).trigger('ac:refresh_complete');
    }
  };

  my.draw_counter = function(counter_id, counter) {
    var c = (counter == 0 || counter == '0') ? '' : counter;
    $('.ac_counter[data-id="' + counter_id + '"]').html(c);
  };

  my.prepare_counters = function(session_stored_counters) {
    $('.ac_counter').each(function() {
      var $this = $(this);
      var counter_id = $this.attr('data-id');

      if (counter_id) {
        if (session_stored_counters && (session_stored_counters[counter_id] || session_stored_counters[counter_id] === 0)) {
          my.draw_counter(counter_id, session_stored_counters[counter_id]);
        } else {
          my.expired_ajax_counters.push(counter_id);
        }
      }
    });
  };

  my.initialize = function(session_stored_counters) {
    $(document).ready(function() {
      my.prepare_counters(session_stored_counters);
      my.refresh_ajax_counters();
    });
  };

  return my;
})(RMPlus.AC || {});

$(document).ready(function () {
  $(document.body).on('click', '.ac_refresh', function () {
    RMPlus.AC.expired_ajax_counters = [];
    $('.ac_refresh').hide();
    $('<div class="loader ac_preloader"></div>').insertAfter($(this));
    RMPlus.AC.prepare_counters({});
    RMPlus.AC.refresh_ajax_counters();
    return false;
  });

  $(document.body).on('ac:refresh_complete', function () {
    $('.ac_preloader').remove();
    $('.ac_refresh').show();
  });
});
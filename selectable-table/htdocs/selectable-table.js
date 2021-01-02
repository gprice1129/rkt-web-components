'use strict';

$(document).ready(function() {
  function toggle_row_state(row) {
    if (row.hasClass("active")) {
      row.removeClass("active");
    } else {
      row.addClass("active");
    }
  }

  $('.selectable-row').each(function() {
    const row = $(this);
    row.on('click', function(evt) {
      toggle_row_state(row);
    });
  });
});
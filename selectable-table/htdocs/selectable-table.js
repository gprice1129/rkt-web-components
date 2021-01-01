'use strict';

$(document).ready(function() {
  function toggle_row_state(row) {
    if (row.attr("data-state") === "active") {
      row.removeClass("active");
      row.attr("data-state", "inactive");
    } else {
      row.addClass("active");
      row.attr("data-state", "active");
    }
  }

  $('.selectable-row').each(function() {
    const row = $(this);
    toggle_row_state(row);
    row.on('click', function(evt) {
      toggle_row_state(row);
    });
  });
});
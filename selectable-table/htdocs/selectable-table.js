'use strict';
var data_providers = [];

// Get an ID selector given an ID
function qry_id(id) {
  return '#' + id;
}

// Register a function for gathering data to a jQuery selector. This is used in
// get_data_and_submit to submit data through a form.
//
// param selector: jQuery selector used to register the aggregator to all elements
//                 that match the selector
// param aggregator: Function used to gather data for a specific element
// side effect: global data_providers is modified
function add_data_providers_by_selector(selector, aggregator) {
  let providers = $(selector);
  if (providers.length !== 0) {
    data_providers.push({
      agg: aggregator,
      pids: [...providers].map(function(p) { return qry_id(p.id); })
    });
  }
}

// Get data for all data providers registered through add_data_providers_by_selector
// and submit to the form identifed by #query-data
function get_data_and_submit() {
  let query_data = $("#query-data");
  let data = [];
  data_providers.forEach(function(provider) {
    provider.pids.forEach(function(pid) {
       data.push(provider.agg(pid));
    });
  });

  console.log(JSON.stringify(data));
  $(query_data).attr("value", JSON.stringify(data));
  $("#query").submit();
}

// Toggle row state between active/inactive
//
// param row: jQuery object representing a selectable row
function toggle_row_state(row) {
  if (row.hasClass('active')) {
    row.removeClass('active');
  } else {
    row.addClass('active');
  }
}

// Gather the active row IDs for a specific table
//
// param id: Identifies table to gather active row data from
// return: { id: <table-id>, state: <[active-row-id]> }
function gather_table_data(id) {
  let table = { id: id, state: [] };
  $('.active', id).each(function() {
    const active_row = $(this);
    table.state.push(active_row.attr('data-id'));
  });

  return table; 
}

$(document).ready(function() {
  $('.selectable-row').each(function() {
    const row = $(this);
    row.on('click', function(evt) {
      toggle_row_state(row);
    });
  });

  add_data_providers_by_selector('.selectable-table', gather_table_data)
});
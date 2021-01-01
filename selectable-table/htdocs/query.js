'use strict'

function get_data_and_submit() {
    let query_data = $("#query-data");
    const data = $(".active").map(function() {
        return $(this).attr("data-state");
    }).get().join(",");
    $(query_data).attr("value", data);
    $("#query").submit();
}
$(document).ready(function()
  {

    $('.score').dataTable({
      "order"          : [[ 2, "desc" ]],
      "bFilter"        : false,
      "bInfo"          : false,
      "scrollY"        : "400px",
      "scrollCollapse" : true,
      "paging"         : false,
      dom: 'C<"clear">lfrtip'
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);

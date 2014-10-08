$(document).ready(function()
  {

    $('.score').dataTable({
      order          : [[ 3, "desc" ]],
      bFilter        : false,
      bInfo          : false,
      scrollY        : "400px",
      scrollCollapse : true,
      paging         : false,
      columnDefs     : [{ visible : false, targets : [0,4,5,9,10] }],
      dom            : 'C<"clear">lfrtip'
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);

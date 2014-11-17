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

    $('.coefficient').dataTable({
      order          : [[ 3, "desc" ]],
      paging         : false,
      bFilter        : false,
      dom            : 'C<"clear">lfrtip',
      columnDefs: [
       { type: 'signed-num', targets: [3,4,5,6] }
     ]
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);

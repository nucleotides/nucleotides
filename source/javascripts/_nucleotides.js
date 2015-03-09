$(document).ready(function()
  {

    $('.data-benchmark').dataTable({
      order          : [[ 3, "desc" ]],
      bFilter        : false,
      bInfo          : false,
      scrollY        : "400px",
      scrollCollapse : true,
      paging         : false,
      columnDefs     : [{ visible : false, targets : [0,4,5,9,10] }],
      dom            : 'C<"clear">lfrtip'
    });

    $('.data-missing').dataTable({
      scrollY        : "150px",
      scrollCollapse : true,
      bFilter        : false,
      bInfo          : false,
      paging         : false,
      order          : [[ 2, "desc" ]]
    });

    $('.coefficient').dataTable({
      order          : [[ 3, "desc" ]],
      paging         : false,
      bFilter        : false,
      bInfo          : false,
      dom            : 'C<"clear">lfrtip',
      columnDefs: [
       { type: 'signed-num', targets: [3,4,5,6] },
       { visible : false,    targets : [0] }
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

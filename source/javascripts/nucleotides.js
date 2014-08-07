$(document).ready(function()

  {
    $(".score").tablesorter({
      sortList: [[2,0]],
      cssAsc: 'bg-primary',
      cssDesc: 'bg-primary'
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'focus',
      html: true
      });
  }

);

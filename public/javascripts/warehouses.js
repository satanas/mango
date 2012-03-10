document.observe("dom:loaded", function() {
    $('pdt_select').hide();
    $('pdt_label').hide();
    $('warehouse_warehouse_type_id').observe('change', type_changed);
});

function type_changed() {
    warehouse_type_id = $('warehouse_warehouse_type_id').getValue();
    if (warehouse_type_id == 1) {
      $('pdt_select').hide();
      $('pdt_label').hide();
      $('ing_select').show();
      $('ing_label').show();
    } else {
      $('pdt_select').show();
      $('pdt_label').show();
      $('ing_select').hide();
      $('ing_label').hide();
    }
}


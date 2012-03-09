// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe("dom:loaded", function() {
    hide_all_report_details();
});

function submit_recipe_new_form() {
    $('recipe_new_form').submit();
}

function submit_recipe_edit_form() {
    $('recipe_edit_form').submit();
}

function submit_recipe_upload_form() {
    $('recipe_upload_form').hide();
    $('data_progress').show();
    $('recipe_upload_form').submit();
}

function submit_ingredient_new_form() {
    $('ingredient_new_form').submit();
}

function submit_ingredient_edit_form() {
    $('ingredient_edit_form').submit();
}

function submit_user_new_form() {
    $('user_new_form').submit();
}

function submit_user_edit_form() {
    $('user_edit_form').submit();
}

function submit_hopper_new_form() {
    $('hopper_new_form').submit();
}

function submit_hopper_edit_form() {
    $('hopper_edit_form').submit();
}

function submit_product_new_form() {
    $('product_new_form').submit();
}

function submit_product_edit_form() {
    $('product_edit_form').submit();
}

function submit_order_new_form() {
    $('order_new_form').submit();
}

function submit_order_edit_form() {
    $('order_edit_form').submit();
}

function submit_client_new_form() {
    $('client_new_form').submit();
}

function submit_client_edit_form() {
    $('client_edit_form').submit();
}

function submit_batch_new_form() {
    $('batch_new_form').submit();
}

function submit_batch_edit_form() {
    $('batch_edit_form').submit();
}

function submit_lot_new_form() {
    $('lot_new_form').submit();
}

function submit_lot_edit_form() {
    $('lot_edit_form').submit();
}

function submit_schedule_new_form() {
    $('schedule_new_form').submit();
}

function submit_schedule_edit_form() {
    $('schedule_edit_form').submit();
}

function submit_transaction_type_new_form() {
    $('transaction_type_new_form').submit();
}

function submit_transaction_type_edit_form() {
    $('transaction_type_edit_form').submit();
}

function submit_product_lot_new_form() {
    $('product_lot_new_form').submit();
}

function submit_product_lot_edit_form() {
    $('product_lot_edit_form').submit();
}
function toggle_report_details(id) {
    hide_all_report_details();
    $(id).toggle();
}

function hide_all_report_details() {
    if($('recipes_report_details') != null)
        $('recipes_report_details').hide();
}

function close_error_dialog() {
    $('modal').remove();
}

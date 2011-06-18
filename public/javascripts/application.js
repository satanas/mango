// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

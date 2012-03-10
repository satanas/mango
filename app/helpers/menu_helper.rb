module MenuHelper

  def render_menu
    c = params[:controller]
    a = params[:action]
    if c == 'recipes' and a == 'index'
      menu = menu_for_recipes_index
    elsif c == 'recipes' and a == 'show'
      menu = menu_for_recipes_show
    elsif c == 'recipes' and (a == 'new' or a == 'create')
      menu = menu_for_recipes_new
    elsif c == 'recipes' and (a == 'edit' or a == 'update')
      menu = menu_for_recipes_edit
    elsif c == 'recipes' and a == 'import'
      menu = menu_for_recipes_import
    elsif c == 'ingredients' and a == 'index'
      menu = menu_for_ingredients_index
    elsif c == 'ingredients' and (a == 'new' or a == 'create')
      menu = menu_for_ingredients_new
    elsif c == 'ingredients' and (a == 'edit' or a == 'update')
      menu = menu_for_ingredients_edit
    elsif c == 'users' and a == 'index'
      menu = menu_for_users_index
    elsif c == 'users' and (a == 'new' or a == 'create')
      menu = menu_for_users_new
    elsif c == 'users' and (a == 'edit' or a == 'update')
      menu = menu_for_users_edit
    elsif c == 'hoppers' and a == 'index'
      menu = menu_for_hoppers_index
    elsif c == 'hoppers' and (a == 'new' or a == 'create')
      menu = menu_for_hoppers_new
    elsif c == 'hoppers' and (a == 'edit' or a == 'update')
      menu = menu_for_hoppers_edit
    elsif c == 'products' and a == 'index'
      menu = menu_for_products_index
    elsif c == 'products' and (a == 'new' or a == 'create')
      menu = menu_for_products_new
    elsif c == 'products' and (a == 'edit' or a == 'update')
      menu = menu_for_products_edit
    elsif c == 'orders' and a == 'index'
      menu = menu_for_orders_index
    elsif c == 'orders' and (a == 'new' or a == 'create')
      menu = menu_for_orders_new
    elsif c == 'orders' and (a == 'edit' or a == 'update')
      menu = menu_for_orders_edit
    elsif c == 'clients' and a == 'index'
      menu = menu_for_clients_index
    elsif c == 'clients' and (a == 'new' or a == 'create')
      menu = menu_for_clients_new
    elsif c == 'clients' and (a == 'edit' or a == 'update')
      menu = menu_for_clients_edit
    elsif c == 'batches' and a == 'index'
      menu = menu_for_batches_index
    elsif c == 'batches' and (a == 'new' or a == 'create')
      menu = menu_for_batches_new
    elsif c == 'batches' and (a == 'edit' or a == 'update')
      menu = menu_for_batches_edit
    elsif c == 'lots' and a == 'index'
      menu = menu_for_lots_index
    elsif c == 'lots' and (a == 'new' or a == 'create')
      menu = menu_for_lots_new
    elsif c == 'lots' and (a == 'edit' or a == 'update')
      menu = menu_for_lots_edit
    elsif c == 'schedules' and a == 'index'
      menu = menu_for_schedules_index
    elsif c == 'schedules' and (a == 'new' or a == 'create')
      menu = menu_for_schedules_new
    elsif c == 'schedules' and (a == 'edit' or a == 'update')
      menu = menu_for_schedules_edit
    elsif c == 'transaction_types' and a == 'index'
      menu = menu_for_transaction_types_index
    elsif c == 'transaction_types' and (a == 'new' or a == 'create')
      menu = menu_for_transaction_types_new
    elsif c == 'transaction_types' and (a == 'edit' or a == 'update')
      menu = menu_for_transaction_types_edit
    elsif c == 'product_lots' and a == 'index'
      menu = menu_for_product_lots_index
    elsif c == 'product_lots' and (a == 'new' or a == 'create')
      menu = menu_for_product_lots_new
    elsif c == 'product_lots' and (a == 'edit' or a == 'update')
      menu = menu_for_product_lots_edit
    elsif c == 'warehouses' and a == 'index'
      menu = menu_for_warehouses_index
    elsif c == 'warehouses' and (a == 'new' or a == 'create')
      menu = menu_for_warehouses_new
    elsif c == 'warehouses' and (a == 'edit' or a == 'update')
      menu = menu_for_warehouses_edit
    elsif c == 'transactions' and a == 'index'
      menu = menu_for_transactions_index
    elsif c == 'transactions' and (a == 'new' or a == 'create')
      menu = menu_for_transactions_new
    elsif c == 'transactions' and (a == 'edit' or a == 'update')
      menu = menu_for_transactions_edit
    elsif c == 'reports' and a == 'index'
      menu = menu_for_reports_index
    end

    return content_tag(:div, menu, :id => 'menu')
  end

  private

  def render_action(caption, title, url, image)
    icon = image_tag(image, :alt=>caption, :title=>title, :height=>28, :width=>28)
    return content_tag(:li, link_to(icon, url))
  end

  def render_function(caption, title, function, image)
    icon = image_tag(image, :alt=>caption, :title=>title, :height=>28, :width=>28)
    return content_tag(:li, link_to(icon, '#', :onclick => function))
  end

  def render_back(url)
    return render_action('Volver', 'Volver', url, 'button-back.png')
  end

  def menu_for_recipes_index
    menu = content_tag(:p, 'Lista de recetas')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Importar', 'Importar receta desde archivo', recipe_import_path, 'button-import.png')+
      render_action('Crear', 'Crear nueva receta', new_recipe_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_recipes_show
    menu = content_tag(:p, 'Detalle de receta')
    menu += content_tag(:ul,
      render_back(recipes_path) +
      render_action('Editar', 'Editar receta', edit_recipe_path, 'button-edit.png')
    )
    return menu
  end

  def menu_for_recipes_new
    menu = content_tag(:p, 'Crear nueva receta')
    menu += content_tag(:ul,
      render_back(recipes_path) +
      render_function('Guardar', 'Guardar receta', "submit_recipe_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_recipes_edit
    menu = content_tag(:p, 'Editar receta')
    menu += content_tag(:ul,
      render_back(recipe_path(params[:id])) +
      render_function('Actualizar', 'Actualizar receta', "submit_recipe_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_recipes_import
    menu = content_tag(:p, 'Importar receta')
    menu += content_tag(:ul,
      render_back(recipes_path) +
      render_function('Importar', 'Importar receta', "submit_recipe_upload_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_ingredients_index
    menu = content_tag(:p, 'Lista de materias primas')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nueva materia prima', new_ingredient_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_ingredients_new
    menu = content_tag(:p, 'Crear nueva materia prima')
    menu += content_tag(:ul,
      render_back(ingredients_path) +
      render_function('Guardar', 'Guardar materia prima', "submit_ingredient_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_ingredients_edit
    menu = content_tag(:p, 'Editar materia prima')
    menu += content_tag(:ul,
      render_back(ingredients_path) +
      render_function('Actualizar', 'Actualizar materia prima', "submit_ingredient_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_users_index
    menu = content_tag(:p, 'Lista de usuarios')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo usuario', new_user_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_users_new
    menu = content_tag(:p, 'Crear nuevo usuario')
    menu += content_tag(:ul,
      render_back(users_path) +
      render_function('Guardar', 'Guardar usuario', "submit_user_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_users_edit
    menu = content_tag(:p, 'Editar usuario')
    menu += content_tag(:ul,
      render_back(users_path) +
      render_function('Actualizar', 'Actualizar usuario', "submit_user_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_hoppers_index
    menu = content_tag(:p, 'Lista de tolvas')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nueva tolva', new_hopper_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_hoppers_new
    menu = content_tag(:p, 'Crear nueva tolva')
    menu += content_tag(:ul,
      render_back(hoppers_path) +
      render_function('Guardar', 'Guardar tolva', "submit_hopper_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_hoppers_edit
    menu = content_tag(:p, 'Editar tolva')
    menu += content_tag(:ul,
      render_back(hoppers_path) +
      render_function('Actualizar', 'Actualizar tolva', "submit_hopper_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_products_index
    menu = content_tag(:p, 'Lista de productos terminados')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo producto terminado', new_product_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_products_new
    menu = content_tag(:p, 'Crear nuevo producto terminado')
    menu += content_tag(:ul,
      render_back(products_path) +
      render_function('Guardar', 'Guardar producto terminado', "submit_product_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_products_edit
    menu = content_tag(:p, 'Editar producto terminado')
    menu += content_tag(:ul,
      render_back(products_path) +
      render_function('Actualizar', 'Actualizar producto terminado', "submit_product_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_orders_index
    menu = content_tag(:p, 'Lista de órdenes de producción')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nueva orden de producción', new_order_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_orders_new
    menu = content_tag(:p, 'Crear nueva orden de producción')
    menu += content_tag(:ul,
      render_back(orders_path) +
      render_function('Guardar', 'Guardar orden de producción', "submit_order_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_orders_edit
    menu = content_tag(:p, 'Editar orden de producción')
    menu += content_tag(:ul,
      render_back(orders_path) +
      render_function('Actualizar', 'Actualizar orden de producción', "submit_order_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_clients_index
    menu = content_tag(:p, 'Lista de clientes')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo cliente', new_client_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_clients_new
    menu = content_tag(:p, 'Crear nuevo cliente')
    menu += content_tag(:ul,
      render_back(clients_path) +
      render_function('Guardar', 'Guardar cliente', "submit_client_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_clients_edit
    menu = content_tag(:p, 'Editar cliente')
    menu += content_tag(:ul,
      render_back(clients_path) +
      render_function('Actualizar', 'Actualizar cliente', "submit_client_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_batches_index
    menu = content_tag(:p, 'Lista de batches')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo batch', new_batche_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_batches_new
    menu = content_tag(:p, 'Crear nuevo batch')
    menu += content_tag(:ul,
      render_back(batches_path) +
      render_function('Guardar', 'Guardar batch', "submit_batch_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_batches_edit
    menu = content_tag(:p, 'Editar batch')
    menu += content_tag(:ul,
      render_back(batches_path) +
      render_function('Actualizar', 'Actualizar batch', "submit_batch_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_lots_index
    menu = content_tag(:p, 'Lista de lotes de ingredientes')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo lote', new_lot_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_lots_new
    menu = content_tag(:p, 'Crear nuevo lote de ingredientes')
    menu += content_tag(:ul,
      render_back(lots_path) +
      render_function('Guardar', 'Guardar lote', "submit_lot_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_lots_edit
    menu = content_tag(:p, 'Editar lote de ingredientes')
    menu += content_tag(:ul,
      render_back(lots_path) +
      render_function('Actualizar', 'Actualizar lote', "submit_lot_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_schedules_index
    menu = content_tag(:p, 'Lista de turnos')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo turno', new_schedule_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_schedules_new
    menu = content_tag(:p, 'Crear nuevo turno')
    menu += content_tag(:ul,
      render_back(schedules_path) +
      render_function('Guardar', 'Guardar turno', "submit_schedule_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_schedules_edit
    menu = content_tag(:p, 'Editar turno')
    menu += content_tag(:ul,
      render_back(schedules_path) +
      render_function('Actualizar', 'Actualizar turno', "submit_schedule_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_transaction_types_index
    menu = content_tag(:p, 'Lista de tipos de transacciones')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo tipo de transacción', new_transaction_type_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_transaction_types_new
    menu = content_tag(:p, 'Crear nuevo tipo de transacción')
    menu += content_tag(:ul,
      render_back(transaction_types_path) +
      render_function('Guardar', 'Guardar tipo de transacción', "submit_transaction_type_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_transaction_types_edit
    menu = content_tag(:p, 'Editar tipo de transacción')
    menu += content_tag(:ul,
      render_back(transaction_types_path) +
      render_function('Actualizar', 'Actualizar tipo de transacción', "submit_transaction_type_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_product_lots_index
    menu = content_tag(:p, 'Lista de lotes de producto terminado')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo lote', new_product_lot_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_product_lots_new
    menu = content_tag(:p, 'Crear nuevo lote de producto terminado')
    menu += content_tag(:ul,
      render_back(product_lots_path) +
      render_function('Guardar', 'Guardar lote', "submit_product_lot_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_product_lots_edit
    menu = content_tag(:p, 'Editar lote de producto terminado')
    menu += content_tag(:ul,
      render_back(product_lots_path) +
      render_function('Actualizar', 'Actualizar lote', "submit_product_lot_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_warehouses_index
    menu = content_tag(:p, 'Lista de almacenes')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nuevo almacén', new_warehouse_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_warehouses_new
    menu = content_tag(:p, 'Crear nuevo almacén')
    menu += content_tag(:ul,
      render_back(warehouses_path) +
      render_function('Guardar', 'Guardar almacén', "submit_warehouse_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_warehouses_edit
    menu = content_tag(:p, 'Editar almacén')
    menu += content_tag(:ul,
      render_back(warehouses_path) +
      render_function('Actualizar', 'Actualizar turno', "submit_warehouse_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_transactions_index
    menu = content_tag(:p, 'Lista de transacciones')
    menu += content_tag(:ul,
      render_back(root_path) +
      render_action('Crear', 'Crear nueva transacción', new_transaction_path, 'button-add.png')
    )
    return menu
  end

  def menu_for_transactions_new
    menu = content_tag(:p, 'Crear nueva transacción')
    menu += content_tag(:ul,
      render_back(transactions_path) +
      render_function('Guardar', 'Guardar transacción', "submit_transaction_new_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_transactions_edit
    menu = content_tag(:p, 'Editar transacción')
    menu += content_tag(:ul,
      render_back(transactions_path) +
      render_function('Actualizar', 'Actualizar transacción', "submit_transaction_edit_form()", 'button-execute.png')
    )
    return menu
  end

  def menu_for_reports_index
    menu = content_tag(:p, 'Reportes')
    menu += content_tag(:ul, render_back(root_path))
    return menu
  end
end

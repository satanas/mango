class RecipesController < ApplicationController
  def index
    @recipes = Recipe.paginate :all, :page=>params[:page], :per_page=>session[:per_page], :conditions => ['active = ?', true]
  end

  def show
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe', :order=>'id desc')
  end

  def edit
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe', :order=>'id desc')
    @ingredients = Ingredient.find :all
  end

  def create
    @recipe = Recipe.new params[:recipe]
    if @recipe.save
      flash[:notice] = 'Receta guardada con éxito'
      redirect_to :recipes
    else
      render :new
    end
  end

  def update
    @recipe = Recipe.find params[:id]
    @recipe.update_attributes(params[:recipe])
    if @recipe.save
      flash[:notice] = 'Receta actualizada con éxito'
      redirect_to :recipes
    else
      edit
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find params[:id]
    @ingredients = Ingredient.find :all
    @recipe.eliminate
    if @recipe.errors.size.zero?
      flash[:notice] = "Receta eliminada con éxito"
    else
      logger.error("Error eliminando receta: #{@recipe.errors.inspect}")
      flash[:type] = 'error'
      if not @recipe.errors[:foreign_key].nil?
        flash[:notice] = 'La receta no se puede eliminar porque tiene registros asociados'
      elsif not @recipe.errors[:unknown].nil?
        flash[:notice] = @recipe.errors[:unknown]
      else
        flash[:notice] = "La receta no se ha podido eliminar"
      end
    end
    redirect_to :recipes
  end

  def upload
    if params[:recipe]['datafile'].nil?
      flash[:type] = 'error'
      flash[:notice] = "Debe seleccionar un archivo"
      logger.error(flash[:notice])
      redirect_to :action => 'import'
    else
      overwrite = (params[:recipe]['overwrite'] == '1') ? true : false
      name =  params[:recipe]['datafile'].original_filename
      logger.info("Importando el archivo #{name}")
      tmpfile = Tempfile.new "recipe"
      filepath = tmpfile.path()
      tmpfile.write(params[:recipe]['datafile'].read)
      tmpfile.close()

      @recipe = Recipe.new
      if @recipe.import_new(filepath, overwrite)
        flash[:notice] = "Receta importada con éxito"
        redirect_to :action => 'index'
      else
        flash[:type] = 'error'
        flash[:notice] = "Error importando receta"
        puts "#{@recipe.errors.inspect}"
        if not @recipe.errors[:upload_file].nil?
          flash[:notice] += ". #{@recipe.errors[:upload_file]}"
        elsif not @recipe.errors[:syntax].nil?
          flash[:notice] = "Error de sintaxis en la línea #{@recipe.errors[:syntax]}"
        elsif not @recipe.errors[:unknown].nil?
          flash[:notice] += ". #{@recipe.errors[:unknown]}"
        end
        logger.error(@recipe.errors.inspect)
        redirect_to :action => 'import'
      end
    end
  end

end

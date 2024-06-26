class ProductsController < ApplicationController
    def index
      @products = Product.all
    end
  
    def show
      @product = Product.find(params[:id])
    end
  
    def new
      @product = Product.new
    end
  
    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
      else
        render :new
      end
    end
  
    def edit
      @product = Product.find(params[:id])
    end
  
    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        redirect_to @product, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to products_url, notice: 'Product was successfully destroyed.'
    end
  
    def report_product
      product = Product.find(params[:id])
      @report = Report.new(title: "Segnalazione per #{product.name}", content: "Descrizione del problema...")
      if @report.save
        redirect_to edit_report_path(@report), notice: 'Report creato con successo. Puoi modificarlo qui sotto.'
      else
        redirect_to root_path, alert: 'Errore nella creazione del report.'
      end
    end
  
    private
  
    def product_params
      params.require(:product).permit(:name, :description, :site, :price)
    end
  end
  
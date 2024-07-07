class ReportsController < ApplicationController
    before_action :set_product, only: [:create, :update]
  
    def index
      unless current_user && current_user.isAdministrator
        flash[:alert] = "You are not authorized to access this page. You have been redirected"
        redirect_to root_path
      end
      @reports = Report.all
    end
  
    def show
      @report = Report.find(params[:id])
	  @product = Product.find_by(id_product: @report.id_product) if @report.id_product.present?
    end
  
    def new
      @report = Report.new
    end
  
    def create
      @report = Report.new(report_params)
      @report.id_product = @product.id_product if @product.present?
      if @report.save
        redirect_to @report
      else
        render 'new'
      end
    end
  
    def edit
      @report = Report.find(params[:id])
    end
  
    def update
      @report = Report.find(params[:id])
      @report.id_product = @product.id_product if @product.present?
      if @report.update(report_params)
        redirect_to @report
      else
        render 'edit'
      end
    end
  
    def destroy
      @report = Report.find(params[:id])
      @report.destroy
      redirect_to reports_path
    end

	def destroy_with_product
		@report = Report.find(params[:id])
		@product = Product.find_by(id_product: @report.id_product)
		@report.destroy
		@product.destroy if @product.present?
		redirect_to reports_path
	end
  
    def report_product
      @product = Product.find_by(id_product: params[:id_product])
      unless @product
        redirect_to root_path, alert: 'Prodotto non trovato.'
        return
      end
  
      @report = Report.new(title: "Segnalazione per #{@product.name}", content: "Il prodotto #{@product.name} presenta problemi", id_product: @product.id_product)
      
      if @report.save
        redirect_to edit_report_path(@report), notice: 'Report creato con successo. Puoi modificarlo qui sotto.'
      else
        redirect_to root_path, alert: 'Errore nella creazione del report.'
      end
    end
  
    private
  
    def set_product
      @product = Product.find_by(id_product: params[:id_product]) if params[:id_product].present?
    end
  
    def report_params
      params.require(:report).permit(:title, :content)
    end
  end
  
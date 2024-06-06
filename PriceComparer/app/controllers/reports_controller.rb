class ReportsController < ApplicationController
    def index
      @reports = Report.all
    end
  
    def show
      @report = Report.find(params[:id])
    end
  
    def new
      @report = Report.new
    end
  
    def create
      @report = Report.new(report_params)
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

    def report_product
        product = Product.find(params[:id])
        @report = Report.new(title: "Segnalazione per #{product.name}", content: "Descrizione del problema...")
        
        if @report.save
          redirect_to reports_path, notice: 'Report creato con successo.'
        else
          redirect_to root_path, alert: 'Errore nella creazione del report.'
        end
      end
  
    private
  
    def report_params
      params.require(:report).permit(:title, :content)
    end
  end
  
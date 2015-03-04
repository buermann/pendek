class LinksController < ApplicationController

  # GET /links/1
  # GET /links/1.json
  def show
    @link = Link.find( params[:id].to_i(36) ) 

    if ( params[:preview] ) 
      # render
      render :show 
    else 
      @link.increment(:clicks)
      redirect_to @link.url, status: :moved_permanently
    end
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.find_or_create_by(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to preview_links_path(@link), notice: 'Link was successfully shortened!' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url)
    end
end

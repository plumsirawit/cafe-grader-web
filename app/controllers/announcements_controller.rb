class AnnouncementsController < ApplicationController
  before_action :authenticate
  # before_filter :admin_authorization

  in_place_edit_for :announcement, :published

  # GET /announcements
  # GET /announcements.xml
  def index
    @announcements = Announcement.order(created_at: :desc)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end

  # GET /announcements/1
  # GET /announcements/1.xml
  def show
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  # GET /announcements/new
  # GET /announcements/new.xml
  def new
    @announcement = Announcement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  # GET /announcements/1/edit
  def edit
    @announcement = Announcement.find(params[:id])
  end

  # POST /announcements
  # POST /announcements.xml
  def create
    @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      if @announcement.save
        flash[:notice] = 'Announcement was successfully created.'
        format.html { redirect_to(@announcement) }
        format.xml  { render :xml => @announcement, :status => :created, :location => @announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /announcements/1
  # PUT /announcements/1.xml
  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(announcement_params)
        flash[:notice] = 'Announcement was successfully updated.'
        format.html { redirect_to(@announcement) }
        format.js   {}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js   {}
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  def toggle
    @announcement = Announcement.find(params[:id])
    @announcement.update_attributes( published:  !@announcement.published? )
    respond_to do |format|
      format.js { render partial: 'toggle_button',
                  locals: {button_id: "#announcement_toggle_#{@announcement.id}",button_on: @announcement.published? } }
    end
  end

  def toggle_front
    @announcement = Announcement.find(params[:id])
    @announcement.update_attributes( frontpage:  !@announcement.frontpage? )
    respond_to do |format|
      format.js { render partial: 'toggle_button',
                  locals: {button_id: "#announcement_toggle_front_#{@announcement.id}",button_on: @announcement.frontpage? } }
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.xml
  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to(announcements_url) }
      format.xml  { head :ok }
    end
  end

  private

    def announcement_params
      params.require(:announcement).permit(:author, :body, :published, :frontpage, :contest_only, :title)
    end
end

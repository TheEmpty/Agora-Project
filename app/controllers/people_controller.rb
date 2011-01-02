class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.paginate(:per_page => 10, :page => params[:page], :conditions => ["LOWER(first_name) LIKE LOWER(?) and LOWER(last_name) LIKE LOWER(?)","%#{params[:first_name]}%","%#{params[:last_name]}%"], :order => "#{sorting_column} #{sorting_direction}")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [@people,{:pagination => {:current_page => @people.current_page, :total_pages => @people.total_pages, :per_page => @people.per_page, :total_entries => @people.total_entries}}] }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  private

  def sorting_column
    Person.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end

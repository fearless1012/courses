class Admin::CoursesController < Admin::BaseController
  # GET /courses
  # GET /courses.json
  def index
    respond_to do |format|
      if params[:code]
        @courses = Course.find_all_by_subject_code(params[:code])
      else
        @courses = Course.all
      end
      
      if params[:code] and params[:code].empty?
        format.html { redirect_to admin_courses_path }
        format.json { redirect_to admin_courses_path }
      else
        format.html # index.html.erb
        format.json { render json: @courses }
      end
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id]||params[:course_id])
    @tab = params[:tab] || "info"
    @ref_books = @course.books

    if @tab == 'classes'
      terms = @course.this_year
      @classes = terms.empty? ? {} : Classroom.where("term_id IN (" + terms.collect do |term|
                                                                        term.id
                                                                      end.join(",") + ")").collect do |cl|
          ret = {date: "#{cl.date.strftime('%-d').to_i.ordinalize} #{cl.date.strftime('%b')}", time: cl.time, venue: cl.room, term_id: cl.term_id }
          ret["topics"] = cl.topics.collect do |topic|
            { id: topic.id, ct_status: topic.ct_status, title: topic.title }
          end
        ret
      end
    end

    @course["instructors"] = []
    @course.this_year.each do |term|
      term.faculties.each do |faculty|
        @course["instructors"] << {
          instructor: "#{faculty.prefix} #{faculty.user.name}",
          semester:   term.semester.ordinalize,
          year:       "#{term.academic_year}-#{term.academic_year+1}"
        }
      end
    end
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @legend = "New Course"
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id] || params[:course_id])

    @new_term = Term.new
    @new_topic = @course.topics.build
    @current_ac_year = Time.now.year.to_i
    @current_ac_year -= Time.now.month<6 ? 1 : 0
    @courses_array = Course.all.map do |course|
      ["#{course.subject_code} - #{course.name}", course.id]
    end
    @faculty_array = Faculty.all.map do |faculty|
      [faculty.user.name, faculty.id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to [:admin, @course], notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to [:admin, @course], notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to admin_courses_url }
      format.json { head :no_content }
    end
  end
end

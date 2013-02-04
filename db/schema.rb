# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130204204740) do

  create_table "course_list_items", :force => true do |t|
    t.integer  "department_id"
    t.integer  "course_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "course_list_items", ["course_id"], :name => "index_course_list_items_on_course_id"
  add_index "course_list_items", ["department_id"], :name => "index_course_list_items_on_department_id"

  create_table "courses", :force => true do |t|
    t.string   "subject_code"
    t.string   "name"
    t.integer  "credits"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "hod"
    t.string   "short"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "terms", :force => true do |t|
    t.integer  "course_id"
    t.integer  "academic_year"
    t.integer  "semester"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "terms", ["course_id"], :name => "index_terms_on_course_id"

  create_table "topics", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end

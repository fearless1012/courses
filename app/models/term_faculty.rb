class TermFaculty < ActiveRecord::Base
  belongs_to :term
  belongs_to :faculty
  has_one :course, :through => :term

  attr_accessible :term_id, :faculty_id, :faculty_email
  
  validates_uniqueness_of :term_id, :scope => :faculty_id
end

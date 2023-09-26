class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  TIMEZONE = "Kolkata"
  NAME_REGEXP = /\A[A-Za-z][\w ]{2,}\z/
end

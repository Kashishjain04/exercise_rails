class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  NAME_REGEXP = /\A[A-Za-z][\w ]{2,}\z/
end

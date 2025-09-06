class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class_attribute :default_limit
  self.default_limit = 50
end

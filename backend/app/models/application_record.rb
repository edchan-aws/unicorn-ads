class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  replicated_model()
end

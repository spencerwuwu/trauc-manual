class Target < ApplicationRecord
  has_one :ci_job
  has_many :test_results
end

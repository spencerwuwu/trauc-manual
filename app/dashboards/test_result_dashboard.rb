require "administrate/base_dashboard"

class TestResultDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    target: Field::BelongsTo,
    id: Field::Number,
    date: Field::Number,
    commit: Field::String,
    sat: Field::Number,
    unsat: Field::Number,
    timeout: Field::Number,
    misc: Field::Number,
    exception: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    unknown: Field::Number,
    benchmark: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :target,
    :id,
    :date,
    :commit,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :target,
    :id,
    :date,
    :commit,
    :sat,
    :unsat,
    :timeout,
    :misc,
    :exception,
    :created_at,
    :updated_at,
    :unknown,
    :benchmark,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :target,
    :date,
    :commit,
    :sat,
    :unsat,
    :timeout,
    :misc,
    :exception,
    :unknown,
    :benchmark,
  ].freeze

  # Overwrite this method to customize how test results are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(test_result)
  #   "TestResult ##{test_result.id}"
  # end
end

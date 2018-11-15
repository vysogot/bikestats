class Trip < ActiveRecord::Base

  validates_format_of :start_address,
    :destination_address,
    :with => /.+,.+,.+/,
    message: "is not in 'Street, City, Country' format"

  validates_format_of :date,
    :with => /\d{4}-\d{2}-\d{2}/,
    message: "is not in 'YYYY-mm-dd' format"

  validates_numericality_of :price

end

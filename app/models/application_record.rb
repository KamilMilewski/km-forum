# :nodoc:
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Generates string intended as an HTML anchor.
  def anchor
    "#{self.class}-#{id}"
  end

  private

  # custom validation for picture size.
  def picture_size
    return if picture.size < 5.megabytes
    errors.add(:picture, 'should be less than 5MB')
  end
end

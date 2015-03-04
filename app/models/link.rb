class Link < ActiveRecord::Base
  validates_presence_of :url
  validates_length_of   :url, maximum: 2083
  validate              :is_valid_url

  before_validation     :set_scheme

  def id 
    # Dupe Rails' URL helpers into using the base36 ID, we don't actually need
    # to access the original value anywhere, though it can still be accessed
    # directly via the attributes hash.
    new_record? ? super : super.to_s(36)
  end

  def self.set_scheme(url='')
    (url.present? && url !~ /^[a-zA-Z][\.\-\+a-zA-Z0-9]+:/) ?  url.prepend("http://") : url
  end

  def self.find_or_create_by(attr, &block)
    # Override activerecord to normalize form data before we attempt the find:
    attr[:url] = Link.set_scheme( attr[:url] )
    super(attr, &block)
  end
  
  private 

  def set_scheme # ensure the scheme is set in other contexts
    self.url = Link.set_scheme(url.to_s)
  end

  def is_valid_url
    if url !~ /^https?:\/\// 
      errors.add(:base, 'You may only redirect browsers to hypertext protocols')
    end

    if url !~ /\A#{URI::regexp}\z/
      errors.add(:base, 'You must pass a valid URL')
    end
  end
end

class Comfy::Blog::Post < ActiveRecord::Base
  
  self.table_name = 'comfy_blog_posts'
  
  # -- Relationships --------------------------------------------------------
  belongs_to :blog
  
  has_many :comments,
    :dependent => :destroy
  
  # -- Validations ----------------------------------------------------------
  validates :blog_id, :title, :slug, :year, :month, :content,
    :presence   => true
  validates :slug,
    :uniqueness => { :scope => [:blog_id, :year, :month] },
    :format     => { :with => /\A\w[a-z0-9_-]*\z/i }
  
  # -- paperclip for images with posts --------------------------------------
  
  has_attached_file :image, :styles => { :small => "300x300>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # -- Scopes ---------------------------------------------------------------
  default_scope -> {
    order('published_at DESC')
  }
  scope :published, -> {
    where(:is_published => true)
  }
  scope :for_year, -> year {
    where(:year => year)
  }
  scope :for_month, -> month {
    where(:month => month)
  }
  
  # -- Callbacks ------------------------------------------------------------
  before_validation :set_slug,
                    :set_published_at,
                    :set_date
  
protected
  
  def set_slug
    self.slug ||= self.title.to_s.downcase.slugify
  end
  
  def set_date
    self.year   = self.published_at.year
    self.month  = self.published_at.month
  end
  
  def set_published_at
    self.published_at ||= Time.zone.now
  end
  
end
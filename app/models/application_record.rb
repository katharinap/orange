class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  COLORS = %w(
    #75507b
    #3465a4
    #f57900
    #c17d11
    #73d216
    #cc0000
    #edd400
  ).freeze
end

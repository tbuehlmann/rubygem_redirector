require 'cuba'
require 'http'
require 'json'

class Application < Cuba
  define do
    on get, ':rubygem' do |rubygem|
      response = HTTP.get(rubygem_url(rubygem))

      if response.status.ok?
        json = JSON.parse(response.to_s)
        homepage_url = json['source_code_uri'] || json['homepage_uri']
        res.redirect(homepage_url)
      else
        not_found
      end
    end

    on default do
      not_found
    end
  end

  private

  def rubygem_url(rubygem)
    'https://rubygems.org/api/v1/gems/%s.json' % rubygem
  end

  def not_found
    res.status = 404
    res.write('Rubygem not found. :(')
  end
end

require 'net/http'
require 'uri'

module FoodsoftVokomokum

  class AuthnException < Exception; end

  # Validate user at Vokomokum member system from existing cookies, return user info
  #   When an unexpected condition occurs, raises FoodsoftVokomokum::AuthnException.
  #   When the user was not logged in, returns `nil`.
  def self.check_user(cookies=cookies)
    id = cookies[:Mem] or return
    res = members_req('/check_user', cookies)
    Rails.logger.debug 'Vokomokum check_user returned: ' + res.body
    json = ActiveSupport::JSON.decode(res)
    json['error'] and raise AuthnException.new('Vokomokum login failed: ' + json['error'])
    json['id'].blank? and return
    json['id'] == id or raise AuthnException.new('Vokomokum login failed: different user id');
    {
      id: id,
      first_name: json['given_name'],
      last_name: [json['middle_name'], json['family_name']].compact.join(' '),
      email: json['email']
    }
  rescue ActiveSupport::JSON.parse_error => error
    raise AuthnException.new('Vokomokum login returned an invalid response: ' + error.message)
  end

  # upload ordergroup totals to vokomokum system
  #   type can be one of 'Groente', 'Kaas', 'Misc.'
  def self.upload_amounts(amounts, type, cookies=cookies)
    # submit fresh page
    #res = order_req('/cgi-bin/vers_upload.cgi', {
    #                  'submit': type,
    #                  'paste': export_amounts(data)
    #}, cookies);
  end


  protected

  def self.members_req(path, cookies)
    self.remote_req(FoodsoftConfig[:vokomokum_members_url], path, nil, cookies)
  end

  def self.order_req(path, data=nil, cookies=nil)
    self.remote_req(FoodsoftConfig[:vokomokum_order_url], path, data, cookies)
  end

  def self.remote_req(url, path, data=nil, cookies=nil)
    # only keep relevant cookies
    cookies = cookies.select {|k,v| k=='Mem' or k=='Key'}
    uri = URI.parse(url+path)
    if data.nil?
      req = Net::HTTP::Get.new(uri.request_uri)
    else
      req = Net::HTTP::Post.new(uri.request_uri)
      req.body = data
    end
    req['Cookie'] = cookies.each {|k,v| ERB::Util.url_encode "#{k}=#{v}"}.join('; ')
    res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
    res.code.to_i == 200 or raise AuthnException.new("Could not access Vokomokum, status #{res.code}")
    res
  end

end

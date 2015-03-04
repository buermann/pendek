require 'spec_helper'

describe Link do
  before :all do
    Link.delete_all
  end

  it "saves a valid url" do 
    l = Link.new(url: "http://example.com/:@-._~!$&'()*+,=;:@-._~!$&'()*+,=:@-._~!$&'()*+,==?/?:@-._~!$'()*+,;=/?:@-._~!$" )
    l.save.should be_truthy
  end

  it "should encode the ID in base64" do 
    (0..37).each do |i|
      l = Link.create!(url: i)
      l.attributes['id'].to_s(36).should == l.id
    end
  end

  it "prepends the http schema if none is set" do 
    l = Link.new(url: 'test.com')
    l.valid?.should be_truthy
    l.url.should == "http://test.com"
  end

  it "invalidates a blank url" do
    l = Link.new
    l.valid?.should be_falsey
  end

  it "URLs are valid up to IE8's maximum of 2083 characters" do
    l = Link.new(url: 'http://' + 'a'*2077) 
    l.valid?.should be_falsey
    l.url.chop!
    l.valid?.should be_truthy
    l.save.should be_truthy
  end

  it "invalides URLs with spaces" do 
    l = Link.new(url: "http://test.com?query= param")
    l.valid?.should be_falsey
  end

  it "invalidates URLs with unsafe characters" do
    %w({ } | ^ < > % { } | \ ^).each do |char| 
      l = Link.new(url: "http://test.com?query=#{char}")
      l.valid?.should be_falsey
    end
  end

  it "invalidates various legal URL schema formats that are not hypertext" do
    ['javascript:', 'ftp://', 'chrome-extension://', 'svn+ssh://', 'tag:'].each do |schema|
      l = Link.new(url: schema+"test.com")
      l.valid?.should be_falsey
    end
  end

  it "finds the existing record with find_or_create_by with or without the schema" do
    l = Link.create!( url: "unique.com" )
    Link.find_or_create_by(url: "http://unique.com").id.should == l.id

    l = Link.create!( url: "http://unique2.com" )
    Link.find_or_create_by(url: "unique2.com").id.should == l.id
  end

end

require 'spec_helper'
describe LinksController, :type => :controller do
  render_views

  before(:all) do 
    Link.delete_all
  end

  let(:params) { {} }

  describe "the show action" do
    let(:link) { Link.find_or_create_by(url: 'test.com') }
    let(:params) { { id: link.id } }

    it "should find the link" do
      params[:id] = link.id

      get :show, params

      assigns(:link).id.should  == link.id
      assigns(:link).url.should == link.url
    end

    it "should redirect to the link's url" do
      params[:id] = link.id

      get :show, params

      response.should be_redirect
      response.location.should == link.url
    end

    it "should preview the link if using the preview route" do
      params[:preview] = true

      get :show, params

      assigns(:link).id.should  == link.id
      assigns(:link).url.should == link.url
      response.should be_success
      response.body.should =~ /#{link.url}/
      response.body.should =~ /#{root_url + link.id}/
    end

    it "should increment the redirect count" do
      clicks = link.clicks
      get :show, params
      assigns(:link).clicks.should  == clicks + 1
    end

  end

  describe "the new action" do 
    it "should create a new link object" do
      get :new
      response.should be_success
      assigns(:link).new_record?.should be true
    end

    it "should render the new link form" do
      get :new
      response.should render_template("new")
    end
  end

  describe "the create action" do 
    it "should create a new link" do
      params[:link] = { url: "https://test.com" }

      count = Link.count

      post :create, params
      response.should be_redirect

      Link.count.should == count+1

      assigns(:link).url.should == params[:link][:url]
    end

    it "should give a schemeless link a default scheme" do
      params[:link] = { url: "schemeless.com" }
      post :create, params
      assigns(:link).url.should == "http://schemeless.com"
    end

    it "should find an existing link with a scheme" do
      params[:link] = { url: "https://unique.com" }

      l = Link.find_or_create_by(params[:link])

      count = Link.count

      post :create, params

      Link.count.should == count

      assigns(:link).should == l
    end

    it "should find an existing link with no scheme" do
      params[:link] = { url: "unique.com" }

      l = Link.find_or_create_by(params[:link])
      count = Link.count

      post :create, params

      Link.count.should == count

      assigns(:link).should == l
    end


    it "should redirect to preview on success" do
      params[:link] = { url: "test123.com" }
      post :create, params
      response.should be_redirect
    end

    it "should render errors for an invalid link" do
      params[:link] = { url: "ftp://test.com"+"a"*2090 }

      count = Link.count

      post :create, params

      Link.count.should == count

      response.should be_success
      response.body.should =~ /You may only redirect browsers to hypertext protocols/
      response.body.should =~ /Url is too long/
    end

    describe "test link uniqueness checks against arbitrary real world examples" do
      %w(https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=video&cd=2&cad=rja&uact=8&ved=0CCYQtwIwAQ&url=http%3A%2F%2Fwww.kob.com%2Farticle%2Fstories%2Fs3721534.shtml&ei=vZH2VIXVJomyogTv7oJo&usg=AFQjCNEHhEVvRGFrhqAvsHOLvIMpH84JPg&sig2=Xe_xOb7EU-YPhfxcmRuGlw&bvm=bv.87519884,d.cGU
       https://www.youtube.com/watch?v=l4Rxv4TAHMs
       https://books.google.com/books?id=LVp_gkwyvC8C&pg=PA466&dq=hakemite+zij&hl=en&sa=X&ei=knv3VLjiMoz1oAS2s4HQBQ&ved=0CB4Q6AEwAA#v=onepage&q=hakemite%20zij&f=false
       http://www.dailymotion.com/video/x295c1k_misbah-equals-fastest-test-century-record-02-nov-2014_news
       https://sat.collegeboard.org/about-tests/sat-subject-tests
       http://store.steampowered.com/app/9930/
       http://www.uscis.gov/citizenship/learners/study-test/study-materials-civics-test/uscis-naturalization-interview-and-test-video
        ).each do |url|
          it "should find an existing record for #{url}" do
            l = Link.create!(url: url)
            params[:link] = { url: url}
            count = Link.count
            post :create, params
            Link.count.should == count
            assigns(:link).url.should == url
          end
        end
    end

  end
end

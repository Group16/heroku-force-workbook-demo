require "sinatra/base"
require 'force'
require "omniauth"
require "omniauth-salesforce"


class MyApp < Sinatra::Base

  configure do
    enable :logging
    enable :sessions
    set :show_exceptions, false
    set :session_secret, ENV['SECRET']
  end

  use OmniAuth::Builder do
    provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
  end

  before /^(?!\/(auth.*))/ do   
    redirect '/authenticate' unless session[:instance_url]
  end


  helpers do
    def client
      @client ||= Force.new instance_url:  session['instance_url'], 
                            oauth_token:   session['token'],
                            refresh_token: session['refresh_token'],
                            client_id:     ENV['SALESFORCE_KEY'],
                            client_secret: ENV['SALESFORCE_SECRET']
    end
    
     def clientt
      @client ||= Force.new instance_url:  session['instance_url'], 
                            oauth_token:   session['token'],
                            refresh_token: session['refresh_token'],
                            client_id:     ENV['SALESFORCE_KEY'],
                            client_secret: ENV['SALESFORCE_SECRET']
    end
    def clienttt
      @client ||= Force.new instance_url:  session['instance_url'], 
                            oauth_token:   session['token'],
                            refresh_token: session['refresh_token'],
                            client_id:     ENV['SALESFORCE_KEY'],
                            client_secret: ENV['SALESFORCE_SECRET']
    end
    
     def clientttt
      @client ||= Force.new instance_url:  session['instance_url'], 
                            oauth_token:   session['token'],
                            refresh_token: session['refresh_token'],
                            client_id:     ENV['SALESFORCE_KEY'],
                            client_secret: ENV['SALESFORCE_SECRET']
    end

  end
  date = Time.now

  yr = date.year
  mnt = date.month
  dy = date.day

  mntt =mnt.to_s.rjust(2,'0')
  dyy = dy.to_s.rjust(2,'0')

  d = "#{yr}-#{mntt}-#{dyy}"

  get '/' do
    logger.info "Visited home page"
     @accounts1 = client.query("SELECT FirstName,LastName,MobilePhone,Email FROM User WHERE Id = '00580000003lR2a' OR Id = '00580000003lR5B'
                    OR Id = '00580000003lQuG' OR Id = '005340000082AzV' OR Id = '00580000003muAa' OR Id='005340000082dCX' ")  
     @accounts2 = clientt.query("SELECT owner.name from event where owner.title in ('cloud services engineer','cloud service engineer','Cloud Services Architect','Technical Incident Engineer - vCHS','Technical Incident Engineer - vCloud','Cloud Services Engineer',' Technical Support Engineer') and startdatetime>=#{d}T07:29:00.000Z and enddatetime<=#{d}T17:01:00.000Z and showas = 'busy' and (owner.userroleid = '00E80000001bNmA' or owner.userroleid = '00E80000001bNmy')")
     @accounts3 = clienttt.query("SELECT owner.name from event where owner.title in ('Technical Incident Engineer - vCHS','Technical Incident Engineer - vCloud','Cloud Services Engineer',' Technical Support Engineer') and startdatetime>=#{d}T08:29:00.000Z and enddatetime<=#{d}T21:01:00.000Z and showas = 'busy' and owner.userroleid = '00E80000001bNmy'")
     @accounts4 = clientttt.query("SELECT owner.name from event where owner.title in ('Cloud Services Engineer','Consulting Cloud Architect - vCloud Air','Cloud Service Engineer','Technical Incident Engineer') and startdatetime>=#{d}T13:59:00.000Z and enddatetime<=#{d}T23:31:01.000Z and showas = 'busy' and owner.userroleid = '00E80000001bNmj'")

    erb :index
  end


  get '/authenticate' do
    redirect "/auth/salesforce"
  end


  get '/auth/salesforce/callback' do
    logger.info "#{env["omniauth.auth"]["extra"]["display_name"]} just authenticated"
    credentials = env["omniauth.auth"]["credentials"]
    session['token'] = credentials["token"]
    session['refresh_token'] = credentials["refresh_token"]
    session['instance_url'] = credentials["instance_url"]
    redirect '/'
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/unauthenticate' do
    session.clear 
    'Goodbye - you are now logged out'
  end

  error Force::UnauthorizedError do
    redirect "/auth/salesforce"
  end

  error do
    "There was an error.  Perhaps you need to re-authenticate to /authenticate ?  Here are the details: " + env['sinatra.error'].name
  end

  run! if app_file == $0

end

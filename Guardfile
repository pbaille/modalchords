group :development do
  guard 'coffeescript', :input => 'app/assets/javascripts', :output => 'public/javascripts', :bare => true
  
  guard :compass do
    watch(%r{(.*)\.s[ac]ss$})
  end

  guard 'haml-coffee' do
  	watch(/^.+(\.js\.hamlc)\Z/)
  end

end

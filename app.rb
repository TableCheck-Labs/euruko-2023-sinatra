require 'sinatra'
require 'json'
require 'httparty'

set :public_folder, File.dirname(__FILE__) + '/public'

comments = ["Sveiki!"]

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/comments' do
    comments.reverse().map { |c| "<p>#{c}</p>" }.join
end

post '/comments' do
  comment = Rack::Utils.escape_html(params[:content])

  comment_moderation_result = HTTParty.post("https://api.openai.com/v1/moderations",
    headers: {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}"
    },
    body: {
        input: comment.to_s
    }.to_json
  )

  category_scores = JSON.parse(comment_moderation_result.body)["results"].first["category_scores"]

  if category_scores.values.any? { |score| score > 0.10 }
    puts "Comment was rejected! :("
    "<i>Your comment was rejected! Be nicer!</i>"
  else
    puts "Comment was accepted! :)"
    comments << comment
    "<i>Thank you for your comment!</i>"
  end
end

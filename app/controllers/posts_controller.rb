require 'open-uri'
require 'json'
require 'rubygems'
require 'oauth'


class PostsController < ApplicationController
 def index
   
   if params[:search] != nil
     @search_term = params[:search]
   else
     @search_term = "donut"
   end
   
   # TWITTER, MOTHERFUCKERS
   
   twitter_search_url = "http://search.twitter.com/search.json?q=#{@search_term}%20chicago&rpp=10&include_entities=true&result_type=mixed&limit=100"
   
  @posts = JSON.parse(open(twitter_search_url).read)
  @results = @posts["results"]
  
  # YELP GODS, HELP ME
  
  consumer_key = 'URP-ewUWhBqc5XhufxOpmQ'
  consumer_secret = 'LzupYAlFBrueQpbT7d1BmzpRvF0'
  token = 'a087QZkJQecntmK039oUZlctziW0ZtCv'
  token_secret = 'lBvRE9VBzpwefwP4XpAmZX6_nOE'

  api_host = 'api.yelp.com'

  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
  @access_token = OAuth::AccessToken.new(consumer, token, token_secret)

  path = "/v2/search?term=#{@search_term}&location=chicago&limit=6"
    url = @access_token.get(path).body
    @yelp = JSON.parse(url)
    @reviews = @yelp["businesses"]
 
 # FLICKR AWW YEAAAA
 
  flickr_search_url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=aab1244ad946b691f7dcb14ac5e16804&tags=#{@search_term}&format=json&per_page=12"
  flickr_result = JSON.parse(jsonify(open(flickr_search_url).read))

  new_posts = flickr_result["photos"]

  @photos = new_posts["photo"]

end

def jsonify(string)
  array = string.split("")

  array.pop
  14.times do
    array.shift
  end

  final = array.join("")

  return final
end

  
end


# http://twitter.com/#!/ from_user /status/ ID
# 
# class PostsController < ApplicationController
#   def fetch_posts(num)
#     result = JSON.parse(open("https://graph.facebook.com/me/home?access_token=#{access_token}&limit=#{[100, num].min}").read)
#     new_posts = result["data"]
#     
#     if num > 100
#       result = JSON.parse(open(result["paging"]["next"]).read)
#       new_posts += result["data"]
#     end
# 
#     return new_posts
#   end
#   
#   def index
#     @posts = fetch_posts(50)
#     @posts_with_videos = @posts.select { |post| post["type"] == "video" }
#     @posts_with_geo = @posts.select { |post| post}
#   end
# end
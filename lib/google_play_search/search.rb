require 'rubygems'
require 'nokogiri'
require 'open3'
require 'cgi'
require File.expand_path(File.dirname(__FILE__) + '/app_parser')
require File.expand_path(File.dirname(__FILE__) + '/app_from_url_parser')

module GooglePlaySearch
	class Search
		attr_accessor :current_page, :keyword, :url, :bundle_id

		$GOOGLE_PLAY_STORE_BASE_URL = "https://play.google.com"  

		GOOGLE_PLAY_BASE_SEARCH_URL = $GOOGLE_PLAY_STORE_BASE_URL + "/store/search?q="  
		
    GOOGLE_PLAY_BASE_APP_ID_URL = $GOOGLE_PLAY_STORE_BASE_URL + "/store/apps/details?id="

		DEFAULT_SEARCH_CONDITION = {:language => "en", 
                                :category => "apps", 
                                :per_page_num => 24, 
                                :price => "0",
                                :safe_search => "0",
                                :sort_by => "1"}

		def initialize(search_condition = DEFAULT_SEARCH_CONDITION)
		  @search_condition = DEFAULT_SEARCH_CONDITION.merge(search_condition)
		  @current_page = 1
		end
		
		def search(keyword, options={})
      @current_page = options[:page].nil? ? 1 : options[:page]
		  @keyword = keyword
		  stdin, stdout, stderr = Open3.popen3("curl '#{init_query_url}'")
		  AppParser.new(stdout.read).parse
		end

		def next_page()
		  @current_page =  @current_page + 1
		  search @keyword, { :page => @current_page }
		end

    def get_app_from_url(url)
      stdin, stdout, stderr = Open3.popen3("curl '#{url}'")
      AppFromUrlParser.new(stdout.read).parse
    end

    def get_app_from_bundle_id(bundle_id)
      stdin, stdout, stderr = Open3.popen3("curl '#{init_app_from_id_url(bundle_id)}'")
      AppFromUrlParser.new(stdout.read).parse
    end

		private
  		def init_query_url
  		  query_url = ""
  		  query_url << GOOGLE_PLAY_BASE_SEARCH_URL
  		  query_url << CGI.escape(@keyword) << "&"
  		  query_url << "c="     << @search_condition[:category]    << "&"
  		  query_url << "hl="    << @search_condition[:language]    << "&"
        query_url << "price=" << @search_condition[:price]       << "&"
        query_url << "safe="  << @search_condition[:safe_search] << "&"
        query_url << "sort="  << @search_condition[:sort_by]     << "&"
  		  start = (@current_page - 1) * @search_condition[:per_page_num]
  		  query_url << "start=#{start}&num=#{@search_condition[:per_page_num]}"
  		end

      def init_app_from_id_url(bundle_id)
        app_url = ""
        app_url << GOOGLE_PLAY_BASE_APP_ID_URL
        app_url << bundle_id
      end
	end
end

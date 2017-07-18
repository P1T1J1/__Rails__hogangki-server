class SearchresultController < ApplicationController
    def index
        render file: '#{Rails.root}/index.html'
    end
end

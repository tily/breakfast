FROM ruby
ADD Gemfile .
RUN bundle install
WORKDIR /usr/share/blog

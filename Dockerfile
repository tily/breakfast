FROM ruby
WORKDIR /usr/share/blog
ADD Gemfile .
RUN bundle install

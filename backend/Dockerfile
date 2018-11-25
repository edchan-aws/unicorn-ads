FROM ruby:2.4.2
MAINTAINER sudoamit@

# Install apt based dependencies required to run Rails as 
# well as RubyGems. Ruby image itself is based on a Debian
# image, so we use apt-get.
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \ 
    nodejs

# Configure main working directory. This is the base dir
# used in any further RUN, COPY, and ENTRYPOINT commands.
RUN mkdir /ads
WORKDIR /ads

#COPY Gemfile /ads/Gemfile
#COPY Gemfile.lock /ads/Gemfile.lock
#RUN bundle install

# Copy Gemfile and Gemfile.lock and install RubyGems. This
# is a separate step so that dependencies are cached unless
# changes to either of those files are made.
COPY Gemfile Gemfile.lock /ads/
RUN gem install bundler && bundle install

# Copy the main application.
COPY . /ads

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD ["bundle", "exec", "rails", "server", "-P", "-b", "0.0.0.0" ]

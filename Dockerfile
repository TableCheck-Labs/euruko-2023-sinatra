# Use the official Ruby image as a base image
FROM ruby:3

# Set an environment variable for where the app is installed to inside the docker image
ENV APP_HOME /app

# Create the directory and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install bundler and the necessary gems
RUN gem install sinatra httparty puma

# Environment variables for Rails
ENV RAILS_ENV production
ENV PUMA_MAX_THREADS 20

# Copy the rest of the application
COPY . $APP_HOME/

# Expose port 4567
EXPOSE 4567

# Start the main process.
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]

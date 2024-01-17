require 'rails_helper'

describe Rack::Attack do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  # Your tests
  describe "throttle excessive POST requests to user sign in by IP address" do
    let(:limit) { 5 }

    context "number of requests is lower than the limit" do
      it "does not change the request status" do
        limit.times do |i|
          post "/sign_in", { email: "example3#{i}@gmail.com" }, "REMOTE_ADDR" => "1.2.3.7"
          expect(last_response.status).to_not eq(503)
        end
      end
    end

    context "number of user requests is higher than the limit" do
      it "changes the request status to 503" do
        (limit * 2).times do |i|
          post "/sign_in", { email: "example4#{i}@gmail.com" }, "REMOTE_ADDR" => "1.2.3.9"
          expect(last_response.status).to eq(503) if i > limit
        end
      end
    end
  end

  describe "throttle excessive POST requests to user sign in by email address" do
    let(:limit) { 5 }

    context "number of requests is lower than the limit" do
      it "does not change the request status" do
        limit.times do |i|
          post "/sign_in", { email: "example7@gmail.com" }, "REMOTE_ADDR" => "#{i}.2.6.9"
          expect(last_response.status).to_not eq(503)
        end
      end
    end

    context "number of requests is higher than the limit" do
      it "changes the request status to 503" do
        (limit * 2).times do |i|
          post "/sign_in", { email: "example8@gmail.com" }, "REMOTE_ADDR" => "#{i}.2.7.9"
          expect(last_response.status).to eq(503) if i > limit
        end
      end
    end
  end
end

require 'mongo'
require 'dotenv/load'

class MongoConnector
  def self.client(uri = ENV['db_uri'])
    options = { server_api: {version: "1"} }


    begin
      client = Mongo::Client.new(uri, options)
      admin_client = client.use('admin')
      result = admin_client.database.command(ping: 1)
      puts "Pinged your deployment. You successfully connected to MongoDB!"
      return client
    rescue Mongo::Error::InvalidURI => e
      puts "Invalid MongoDB URI: #{e.message}"
    rescue Mongo::Error::OperationFailure => e
      puts "MongoDB operation failed: #{e.message}"
    rescue RuntimeError => e
      puts "Configuration error: #{e.message}"
    rescue StandardError => e
      puts "An unexpected error occurred: #{e.message}"
    end
    
    nil
  end
end

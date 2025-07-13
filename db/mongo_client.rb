require 'mongo'
require 'dotenv/load'

class MongoConnector
  def self.client(uri = ENV['db_uri'])
    options = { server_api: {version: "1"} }
    client = Mongo::Client.new(uri, options)

    begin
      admin_client = client.use('admin')
      result = admin_client.database.command(ping: 1)
      puts "Pinged your deployment. You successfully connected to MongoDB!"
    rescue Mongo::Error::OperationFailure => ex
      puts ex
    ensure
      client.close
    end
    
    client
  end
end

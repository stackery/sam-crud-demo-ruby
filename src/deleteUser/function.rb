require "aws-sdk"

def handler(event:, context:)
  input_id =  event["body"]["id"]

  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  begin
    # Use dynamodb to delete user from the table
    result = dynamodb.delete_item({
      key: {
        "id" => input_id,
      }, 
      table_name: table_name, 
    })

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error writing to table #{table_name}:"
    puts error.message
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": "User #{input_id} deleted!"
  }

  return response
end

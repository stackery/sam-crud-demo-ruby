require "aws-sdk"

def handler(event:, context:)
  input_id =  event["body"]["id"]

  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  begin
    # Use dynamodb to get user from the table
    result = dynamodb.get_item({
      key: {
        "id" => input_id,
      }, 
      table_name: table_name,
    })

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error getting data from table #{table_name}:"
    puts error.message
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": result
  }

  return response
end

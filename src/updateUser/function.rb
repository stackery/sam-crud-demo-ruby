require "aws-sdk"
require "json"

def handler(event:, context:)
  user = event["body"]
  user_id =  event["body"]["id"]

  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  begin
    # Add a new user to the table
    result = dynamodb.update_item({
      key: {
        "id" => user_id,
      },
      attribute_updates: {
        "FirstName" => {
          value: user["firstName"],
          action: "PUT",     
        },
        "LastName" => {
          value: user["lastName"],
          action: "PUT",     
        },
        "FavoriteColor" => {
          value: user["color"],
          action: "PUT",     
        },
      },
      return_values: "UPDATED_NEW",
      table_name: table_name,
    })
    puts "Updating user #{user_id}."

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error writing to table #{table_name}:"
    puts error.message
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": result
  }

  return response
end

require "aws-sdk"
require "json"

def handler(event:, context:)
  user = event["body"]
  context = JSON.generate(context.inspect)

  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  params = {
    table_name: table_name,
    item: {
      "id" => user["id"],
      "FirstName" => user["firstName"],
      "LastName" => user["lastName"],
      "FavoriteColor" => user["color"]
    }, 
    return_consumed_capacity: "TOTAL",
    condition_expression: "attribute_not_exists(id)"
  }

  begin
    # Add a new user to the table
    dynamodb.put_item(params)
    item_id = params[:item]["id"]
    puts "Writing item #{item_id} to table #{table_name}."

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error writing to table #{table_name}:"
    puts error.message
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": "Success!"
  }

  return response
end

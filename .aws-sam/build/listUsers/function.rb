require "aws-sdk"

def handler(event:, context:)
  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"]

  begin
    # Use dynamodb to get users from the table
    result = dynamodb.scan({
      table_name: table_name,
    })

    for item in result[:items] do
      item_id = item["id"]
      first_name = item["FirstName"]
      last_name = item["LastName"]
      favorite_color = item["FavoriteColor"]
      puts "User #{item_id}: #{first_name} #{last_name}, #{favorite_color}"
    end

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error fetching table #{table_name}. Make sure this function is running in the same environment as the table."
    puts "#{error.message}"
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": result[:items]
  }

  return response
end

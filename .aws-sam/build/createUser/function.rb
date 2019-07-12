require 'aws-sdk'
require 'json'

def handler(event:, context:)
  event: JSON.generate(event)
  context: JSON.generate(context.inspect)

  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV['TABLE_NAME']
  user = event['body']

  params = {
    table_name: table_name,
    item: {
      'id' => {'S': user['id']},
      'FirstName' => {'S': user['firstName']},
      'LastName' => {'S': user['lastName']},
      'FavoriteColor' => {'S': user['color']}
    }, 
    return_consumed_capacity: 'TOTAL',
    condition_expression: 'attribute_not_exists(id)'
  }

  begin
    # Write a new item to the ItemTable
    dynamodb.put_item(params)
    item_id = params[:item]['id']
    puts 'Writing item #{item_id} to table #{table_name}.'

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts 'Error writing to table #{table_name}. Make sure this function is running in the same environment as the table.'
    puts '#{error.message}'
  end

  # Return a 200 response if no errors
  response = {
    'statusCode': 200,
    'body': 'Success!'
  }

  return response
end

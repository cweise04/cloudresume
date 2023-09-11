import logging
from azure.cosmos import CosmosClient
import azure.functions as func

COSMOS_ENDPOINT = "https://cwcloudresume.documents.azure.com:443/"

COSMOS_KEY = "s6vPeSXpDNXLEUPpmyR7qyQ1FLKxmCKVNrCiqlxsJUBFsWu0jYlk3THyTntqUq4XijmtdfiWWeepACDbjtEyIg=="

DATABASE_NAME = "AzureResume"

CONTAINER_NAME = "Counter"


client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
database = client.get_database_client(DATABASE_NAME)
container = database.get_container_client(CONTAINER_NAME)


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
  

    try:
        # Statically define the ID of the item you wish to update
        id_to_update = "1"

        # Query for the item in CosmosDB
        items = list(container.query_items(
            query=f"SELECT * FROM c WHERE c.id = @id",
            parameters=[
                {"name": "@id", "value": id_to_update}
            ],
            enable_cross_partition_query=True
        ))
        print('hello6')
        if not items:
            return func.HttpResponse(
                f"No items found with id: {id_to_update}",
                status_code=404
            )
        print('hello7')
        item = items[0]

        # Statically define the field name you want to increment and perform the increment
        if 'count' in item:
            item['count'] += 1
        else:
            return func.HttpResponse(
                f"Field 'count' not found in the item with id: {id_to_update}",
                status_code=404
            )
        print('hello8')
        # Update the item
        container.upsert_item(item)

        return func.HttpResponse("Item value incremented successfully!")
    except Exception as e:
        return func.HttpResponse(
            f"Error: {e}",
            status_code=500
        )


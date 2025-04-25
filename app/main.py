import hashlib

import redis
from fastapi import FastAPI, Response
from starlette.status import HTTP_200_OK

app = FastAPI()

# Take as input a string message. Store the message and return its SHA256 hash.
# Take as input a SHA256 hash. If that message has been previously stored, return the
# message associated with that hash.

# Will need to be updated if deployed
redis_client = redis.Redis(
    host="hashy-redis.yixyqy.0001.use1.cache.amazonaws.com", port=6379
)


@app.post("/hashy/{string_message}")
def post_string(string_message: str):
    hash_data = hashlib.sha256(string_message.encode("utf-8"))
    hex_string = hash_data.hexdigest()
    redis_client.set(hex_string, string_message)
    return hex_string


@app.get("/hashy/{string_hash}")
def get_message(string_hash: str):
    result = redis_client.get(string_hash)
    # fastapi jsonifies responses.  Just return plain text
    return Response(content=result, status_code=HTTP_200_OK)

import requests
import os
from dotenv import load_dotenv
import json

load_dotenv()
__KEY = os.getenv('API_KEY')

f = open("../text_files/animals.txt", "r")

result = list()

for name in f.readlines():
    api_url = f'https://api.api-ninjas.com/v1/animals?name={name.strip()}'

    response = requests.get(api_url, headers={'X-Api-Key': __KEY})

    if response.status_code == requests.codes.ok:
        for item in response.json():
            if not item in result:
                result.append(item)
    else:
        print("Error:", response.status_code, response.text)

f.close()

with open("animals.json", "w") as output_file:
    json.dump(result, output_file, indent=4)
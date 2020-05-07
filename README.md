# xalgo-parse-api

Simple web API to send .rule and .table files to. Currently, for security
reasons, the system filters out all non-ascii characters.

## Usage

_Rules_ can be posted as plaintext to `/api/v5/parse/rule`

_Tables_ can be posted as plaintext to `/api/v5/parse/table`

Various languages can send POST requests with a plaintext body; some popular
samples are included below.

For instance, sending:

```
META
  VERSION "0.0.1"
  MAINTAINER "Don Kelly <karfai@gmail.com>";

REQUIRE refine:table0:0.0.1 AS table0;
ARRANGE table0 AS table_shift_r3 USING shift(3);
ARRANGE table0 AS table_shift_l9 USING shift(-9);
ARRANGE table0 AS table_invert USING invert();
```

Will return the syntax tree:

```json
{
  "meta": {
    "version": "0.0.1",
    "maintainer": "Don Kelly <karfai@gmail.com>"
  },
  "steps": [
    {
      "reference": {
        "package": "refine",
        "id": "table0",
        "version": "0.0.1",
        "name": "table0"
      },
      "indexes": [],
      "name": "require"
    },
    {
      "table": "table0",
      "table_name": "table_shift_r3",
      "arrangements": [
        {
          "type": "function",
          "name": "shift",
          "args": [
            {
              "type": "number",
              "value": "3"
            }
          ]
        }
      ],
      "name": "arrange"
    },
    {
      "table": "table0",
      "table_name": "table_shift_l9",
      "arrangements": [
        {
          "type": "function",
          "name": "shift",
          "args": [
            {
              "type": "number",
              "value": "-9"
            }
          ]
        }
      ],
      "name": "arrange"
    },
    {
      "table": "table0",
      "table_name": "table_invert",
      "arrangements": [
        {
          "type": "function",
          "name": "invert",
          "args": []
        }
      ],
      "name": "arrange"
    }
  ]
}
```

### Python

```py
import requests

url = "https://xalgo-parser.herokuapp.com/api/v5/parse/rule"

payload = rulebody # load the rule file in as a variable
headers = {
  'Content-Type': 'text/plain'
}

response = requests.request("POST", url, headers=headers, data = payload)

print(response.text.encode('utf8'))
```

### Node

```js
var request = require("request");
var options = {
  method: "POST",
  url: "https://xalgo-parser.herokuapp.com/api/v5/parse/rule",
  headers: {
    "Content-Type": "text/plain",
  },
  body: rulebody, // load the rule file in as a variable.
};
request(options, function (error, response) {
  if (error) throw new Error(error);
  console.log(response.body);
});
```

### Golang

```go
package main

import (
  "fmt"
  "strings"
  "net/http"
  "io/ioutil"
)

func main() {

  url := "http://localhost:4567/api/v5/parse/rule"
  method := "POST"

  payload := strings.NewReader(filecontent) // load the rule file in as a variable.

  client := &http.Client {
  }
  req, err := http.NewRequest(method, url, payload)

  if err != nil {
    fmt.Println(err)
  }
  req.Header.Add("Content-Type", "text/plain")

  res, err := client.Do(req)
  defer res.Body.Close()
  body, err := ioutil.ReadAll(res.Body)

  fmt.Println(string(body))
}
```

## Development

```
bundle install
bundle exec ruby server.rb
```

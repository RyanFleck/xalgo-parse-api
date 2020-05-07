# xalgo-parse-api

Simple web API to send **xalgo** language .rule and .table files to. Relies on the
_lib-rules-parse-ruby_
[gem](https://github.com/Xalgorithms/lib-rules-parse-ruby).
Implements a simple frontend for casual users to tinker.
Currently, for security reasons, the system filters out all non-ascii characters.

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

EFFECTIVE
  IN "CA-ON"
  FROM "2018-04-01T00:00"
  TO "9999-12-30T23:59"
  TIMEZONE "America/Toronto"
  FOR "key0";

WHEN items:a == 1;

REQUIRE assemble:origin:0.0.1 AS table_origin;
REQUIRE assemble:join:0.0.1 AS table_join;

ASSEMBLE table0
  COLUMNS (a, c) FROM table_origin
  COLUMN p FROM table_join;
```

Will return the syntax tree:

```json
{
  "meta": {
    "version": "0.0.1",
    "maintainer": "Don Kelly <karfai@gmail.com>"
  },
  "effective": [
    {
      "jurisdictions": ["CA-ON"],
      "starts": "2018-04-01T00:00",
      "ends": "9999-12-30T23:59",
      "timezone": "America/Toronto",
      "keys": ["key0"]
    }
  ],
  "whens": {
    "items": [
      {
        "expr": {
          "left": {
            "scope": "items",
            "key": "a",
            "type": "reference"
          },
          "right": {
            "type": "number",
            "value": "1"
          },
          "op": "eq"
        }
      }
    ]
  },
  "steps": [
    {
      "reference": {
        "package": "assemble",
        "id": "origin",
        "version": "0.0.1",
        "name": "table_origin"
      },
      "indexes": [],
      "name": "require"
    },
    {
      "reference": {
        "package": "assemble",
        "id": "join",
        "version": "0.0.1",
        "name": "table_join"
      },
      "indexes": [],
      "name": "require"
    },
    {
      "table_name": "table0",
      "columns": [
        {
          "table": "table_origin",
          "sources": [
            {
              "columns": ["a", "c"]
            }
          ]
        },
        {
          "table": "table_join",
          "sources": [
            {
              "name": "p",
              "source": "p"
            }
          ]
        }
      ],
      "name": "assemble"
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

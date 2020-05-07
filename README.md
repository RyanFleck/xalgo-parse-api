# xalgo-parse-api

Simple web API to send .rule and .table files to.

## Usage

_Rules_ can be posted as plaintext to `/api/v5/parse/rule`

_Tables_ can be posted as plaintext to `/api/v5/parse/table`

Various languages can send POST requests with a plaintext body; here are some popular samples:

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

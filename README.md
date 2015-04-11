# Transient Watch Server

To start the server run the command below.
```
coffee server.coffee (api|data)
```

The type of server to start must be specified with `api` or `data`.

## Endpoints

### GET `/events`

Returns a list of events in the format:

```json
{
  "status": "success",
  "data": {
    "designation": "HD 123-456",
    "image": "http://www.example.com/image.jpg",
    "ra": 123.4,
    "dec": 456.7,
    "period": 234.5,
    "measurements" : [
      {
        "source": "Maxi",
        "radiance": 123,
      }
    ]
  }
}
```

### POST `/register`

Register an email or phone number to recieve notifications of a significant event.

Require JSON Body:

```json
{
  "phone": "1-777-111-2234",
  "email": "uncle.sam@example.com",
  "type": "designation|all|region",
  "value": "..."
}
```

Returns:

```
{
 "status": "success"
}
```

### DELETE `/register`

Unregister an email or phone number to stop notifications of significant events.

Required JSON Body:

```json
{
  "phone": "1-777-111-2234",
  "email": "uncle.sam@example.com",
  "type": "designation|all|region"
}
```

Returns:

```
{
 "status": "success"
}
```

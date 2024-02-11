[
  {
    "name": "myapp",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/myapp",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
                {
                    "name": "BACKEND_CONFIG",
                    "value": "dynamodb"
                },
                {
                    "name": "STORAGE_CONFIG",
                    "value": "s3"
                },
                {
                    "name": "STORAGE_ACCESS_SESSION_DURATION",
                    "value": "5"
                },
                {
                    "name": "S3_STORAGE_BUCKET_NAME",
                    "value": "tf-registry"
                },
                {
                    "name": "S3_STORAGE_BUCKET_REGION",
                    "value": "us-east-1"
                },
                {
                    "name": "API_MAX_BODY_SIZE",
                    "value": "100M"
                },
                {
                    "name": "REGISTRY_GPG_KEYS_0__ID",
                    "value": "D17C807B4156558133A1FB843C7461473EB779BD"
                },
                {
                    "name": "REGISTRY_GPG_KEYS_0__ASCII_ARMOR",
                    "value": "D17C807B4156558133A1FB843C7461473EB779BD"
                },
                {
                    "name": "AUTH_ENDPOINT",
                    "value": ""
                },
                {
                    "name": "AUTH_CLIENT_ID",
                    "value": ""
                },
                {
                    "name": "AUTH_CLIENT_SECRET",
                    "value": ""
                },
                {
                    "name": "AUTH_TOKEN_PATH",
                    "value": ""
                },
                {
                    "name": "AUTH_ROLE_SOURCE",
                    "value": ""
                },
                {
                    "name": "AUTH_TOKEN_ATTRIBUTE_EMAIL",
                    "value": ""
                },
                {
                    "name": "AUTH_TOKEN_ATTRIBUTE_GIVEN_NAME",
                    "value": ""
                },
                {
                    "name": "AUTH_TOKEN_ATTRIBUTE_FAMILY_NAME",
                    "value": ""
                },
                {
                    "name": "AUTH_TOKEN_ATTRIBUTE_PREFERRED_USERNAME",
                    "value": ""
                },
                {
                    "name": "END_SESSION_PATH",
                    "value": ""
                }         
    ]
  }
]
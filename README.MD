# LLM Integration Setup with Open Web UI, LiteLLM, and AWS Bedrock

This setup provides a unified interface to call hundreds of remote and local AI models while tracking billing and usage across platforms.

## Access Links After Configuration

- **Open Web UI (Main Chatbot Interface)**: [http://localhost:3000](http://localhost:3000)
- **LiteLLM Dashboard** (Cost & Model Management): [http://localhost:4000/ui](http://localhost:4000/ui)
    - *Credentials are defined in the .env.docker file*

> **Note:** You must complete the configuration steps below before attempting to access these links!

## Prerequisites

- Docker and Docker Compose
- AWS Account with Bedrock access
- AWS IAM credentials with Bedrock permissions
- Optional: Ollama (installed separately)

## Configuration Steps

### 1. Copy the Docker example environment files:
```bash
cp .env.litellm.example .env.litellm
cp .env.openui.example .env.openui
```

### 2. Configure AWS Bedrock Model Access
- Enable individual models in AWS Bedrock: [AWS Bedrock Model Access Console](https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess)
- Follow AWS documentation to enable specific models
- Create an IAM user on AWS with policy below and [AWS generate access credentials](https://www.youtube.com/watch?v=lntWTStctIE)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:ListFoundationModels"
      ],
      "Resource": [
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0",
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-haiku-20240307-v1:0",
        "arn:aws:bedrock:*::foundation-model/meta.llama3-8b-instruct-v1:0",
        "arn:aws:bedrock:*::foundation-model/mistral.mixtral-8x7b-instruct-v0:1"
      ]
    }
  ]
}
```

### 3. Check Available Bedrock Models
List available models in your region using AWS CLI on your terminal (installed separately):
```bash
# List Bedrock foundation models
aws bedrock list-foundation-models --region us-east-1 > available_models.txt
```

### 4. Configure AWS Credentials
Update `.env.litellm` file with your AWS credentials:
```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
```

### 5. LiteLLM Configuration
Edit `litellm/config.yaml` to include Bedrock models:
Please note that there is a `bedrock/` prefix before Bedrock models.
```yaml
model_list:
- model_name: bedrock-claude-3-sonnet
  litellm_params:
    model: bedrock/anthropic.claude-3-sonnet-v1:0

- model_name: bedrock-claude-3-haiku
  litellm_params:
    model: bedrock/anthropic.claude-3-haiku-v1:0
```

### 6. Open Web UI Connections

You can change the connection settings by navigating to: Profile > Settings > Admin Settings > Connections

You can also update `.env.openui` file with your credentials:
```
# Open Web UI - Overriden to connect to LiteLLM instead
OPENAI_API_BASE_URL=http://host.docker.internal:4000/v1 # default url to LiteLLM container
OPENAI_API_KEY=litellm-password                      # change this to LITELLM_MASTER_KEY value

# Open Web UI - OLLama
OLLAMA_BASE_URL=http://host.docker.internal:11434
ENABLE_OLLAMA_API=true # disable if not using
```

## Docker Compose Commands
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down
```

## Troubleshooting

- Ensure AWS IAM policy allows Bedrock model access
- Verify network connectivity
- Check LiteLLM and Open Web UI logs for configuration errors

## Additional Resources

- [AWS Bedrock Model Access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access-modify.html)
- [LiteLLM Configuration](https://github.com/aws-samples/bedrock-litellm)

## Performance and Cost Optimization

- Monitor model usage and costs through LiteLLM dashboard
- Experiment with different models to find the right balance of performance and cost

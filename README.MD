# LLM Integration Setup with Open Web UI, LiteLLM, and AWS Bedrock

This setup provides a unified interface to call hundreds of remote and local AI models while tracking billing and usage across platforms.

## Prerequisites

- Docker and Docker Compose
- AWS Account with Bedrock access
- AWS IAM credentials with Bedrock permissions
- Optional: Ollama (installed separately)

## Configuration Steps

### 1. Copy the Docker example environment file:
   ```
   cp .env.docker.example .env.docker
   ```

### 2. AWS Bedrock Model Access
Enable individual models in AWS Bedrock:
- Navigate to: [AWS Bedrock Model Access Console](https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess)
- Follow AWS documentation to enable specific models

### 3. Check Available Bedrock Models
List available models in your region using AWS CLI:
```
# List Bedrock foundation models
aws bedrock list-foundation-models --region us-east-1 > available_models.txt
```

### 4. Configure AWS Credentials
Create an `.env.docker` file with your AWS credentials:
```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
```

### 5. LiteLLM Configuration
Edit `litellm/config.yaml` to include Bedrock models:
Please note that there is a `bedrock/` prefix before Bedrock models.
```
model_list:
- model_name: bedrock-claude-3-sonnet
  litellm_params:
  model: bedrock/anthropic.claude-3-sonnet-v1:0

- model_name: bedrock-claude-3-haiku
  litellm_params:
  model: bedrock/anthropic.claude-3-haiku-v1:0
```
### 6. Open Web UI Connections

When setting up Open Web UI, use these API endpoints:

- OpenAI API (LiteLLM): http://host.docker.internal:4000/v1
- Ollama API: http://host.docker.internal:11434

## Docker Compose Commands
```
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

### Performance and Cost Optimization

- Monitor model usage and costs through LiteLLM dashboard
- Experiment with different models to find the right balance of performance and cost


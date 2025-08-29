az container create \
--resource-group visiongate-rg \
--name visiongate-backend \
--image martell0x1/visiongate-backend:latest \
--ports 3000 \
--dns-name-label visiongate.backend.azure.com \
--location eastus \
--os-type Linux \
--cpu 1 \
--memory 1.5


az container start --resource-group visiongate-rg --name visiongate-backend
az container stop --resource-group visiongate-rg --name visiongate-backend

